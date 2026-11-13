#Requires -Version 5.1
<#
.SYNOPSIS
    dot - tiny dotfiles manager (PowerShell port of the bash `dot` script).
.DESCRIPTION
    Links the entries of a manifest from the dotfiles repo into $HOME.

      dot.ps1                    Link every entry of the manifest
      dot.ps1 -a PATH [PATH...]  Move PATH into the repo, link it back, add it to the manifest
      dot.ps1 -n ...             Dry run: show what would happen, change nothing

    Manifest ($DOTFILES\manifest), one entry per line, "#" starts a comment:
      source|destdir   $DOTFILES\source  ->  $HOME\destdir\<basename of source>
      source           $DOTFILES\source  ->  $HOME\<basename of source>

      "source" may use wildcards in its last segment (bin/*|.local/bin).
      "destdir" may use ~ and %ENV% variables, or be an absolute path
      (e.g. nvim|%LOCALAPPDATA%). Forward slashes are fine everywhere.

    Existing targets are renamed to <target>.backup<yyyyMMdd-HHmmss>.
.NOTES
    Creating symlinks on Windows needs an elevated prompt or Developer Mode
    (Settings > For developers). If a directory symlink fails, a junction is
    created instead.
.EXAMPLE
    .\dot.ps1 -a .\.vimrc
.EXAMPLE
    .\dot.ps1 -Manifest .\manifest.windows -n
#>

[CmdletBinding(PositionalBinding = $false)]
param(
    [Alias('a')] [string[]] $Add,
    [Parameter(ValueFromRemainingArguments = $true)] [string[]] $Rest,
    [Alias('n')] [switch] $DryRun,
    [Alias('h')] [switch] $Help,
    [string] $Manifest
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# SETTINGS
# ---------------------------------------------------------------------------

$IsWin = [IO.Path]::DirectorySeparatorChar -eq '\'
$Sep   = [string][IO.Path]::DirectorySeparatorChar
$Cmp   = if ($IsWin) { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$script:Linked = 0; $script:Skipped = 0; $script:BackedUp = 0
$script:Missing = 0; $script:Failed = 0

# ---------------------------------------------------------------------------
# HELPERS
# ---------------------------------------------------------------------------

function Show-Usage {
    @'
Usage:
  dot.ps1 [-n]               Link every entry of the manifest into $HOME
  dot.ps1 -a PATH... [-n]    Move PATH (file or dir) to $DOTFILES\<basename>,
                             link it back and add it to the manifest
                             (~\.vimrc -> ".vimrc", ~\.local\bin\x -> "x|.local/bin")
  dot.ps1 -h                 Show this help

Options:
  -n, -DryRun                Show what would happen, change nothing
  -Manifest FILE             Use another manifest (default: $DOTFILES\manifest)

Manifest, one entry per line, "#" starts a comment:
  source|destdir   $DOTFILES\source  ->  $HOME\destdir\<basename of source>
  source           $DOTFILES\source  ->  $HOME\<basename of source>

  "source" may use wildcards in its last segment; every match is linked.
  "destdir" may use ~ and %ENV% variables, or be an absolute path.

Examples:
  HOME/vim|.config      $DOTFILES\HOME\vim   ->  $HOME\.config\vim
  bin/*|.local/bin      $DOTFILES\bin\<each> ->  $HOME\.local\bin\<each>
  nvim|%LOCALAPPDATA%   $DOTFILES\nvim       ->  %LOCALAPPDATA%\nvim
  .tmux.conf            $DOTFILES\.tmux.conf ->  $HOME\.tmux.conf
  # .emacs              commented, does nothing

Existing targets are renamed to <target>.backup<yyyyMMdd-HHmmss>.
'@ | Write-Host
}

function Write-Status {
    param([string] $Tag, [string] $Message)
    $colours = @{
        LINK = 'Green'; ADD = 'Green'; SKIP = 'Yellow'; MISSING = 'Yellow'
        WARN = 'Yellow'; BACKUP = 'Cyan'; MANIFEST = 'Cyan'; ERROR = 'Red'
        DRY = 'Magenta'; INFO = 'Gray'
    }
    Write-Host ("[$Tag]".PadRight(11)) -ForegroundColor $colours[$Tag] -NoNewline
    Write-Host " $Message"
}

function Invoke-Step {
    param([string] $Description, [scriptblock] $Action)
    if ($DryRun) { Write-Status DRY $Description } else { & $Action }
}

function ConvertTo-NativePath {
    param([string] $Path)
    return $Path.Replace('\', $Sep).Replace('/', $Sep)
}

function Get-FullPath {
    param([string] $Path)
    $p = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    $p = [IO.Path]::GetFullPath($p)
    $root = [IO.Path]::GetPathRoot($p)
    if ($p.Length -gt $root.Length) { $p = $p.TrimEnd('\', '/') }
    return $p
}

function Test-SamePath {
    param([string] $A, [string] $B)
    return [string]::Equals($A, $B, $Cmp)
}

function Test-IsInside {
    param([string] $Path, [string] $Dir)
    return $Path.StartsWith($Dir.TrimEnd('\', '/') + $Sep, $Cmp)
}

function Get-ItemSafe {
    param([string] $Path)
    return Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
}

# True for files, directories and also dangling symlinks
function Test-Exists {
    param([string] $Path)
    return $null -ne (Get-ItemSafe $Path)
}

function Test-IsLink {
    param($Item)
    return ($null -ne $Item) -and ($Item.LinkType -in 'SymbolicLink', 'Junction')
}

function Get-LinkTarget {
    param($Item)
    $t = @($Item.Target)[0]
    if (-not $t) { return $null }
    $t = $t -replace '^\\\?\?\\', ''
    if (-not [IO.Path]::IsPathRooted($t)) {
        $t = Join-Path (Split-Path $Item.FullName -Parent) $t
    }
    return [IO.Path]::GetFullPath($t)
}

# Like `readlink -f`: resolves every symlink/junction along the path
function Resolve-RealPath {
    param([string] $Path, [int] $Depth = 0)
    $full = Get-FullPath $Path
    $root = [IO.Path]::GetPathRoot($full)
    $cur  = $root
    $parts = $full.Substring($root.Length) -split '[\\/]' | Where-Object { $_ }
    foreach ($part in $parts) {
        $cur = Join-Path $cur $part
        if ($Depth -lt 16) {
            $item = Get-ItemSafe $cur
            if (Test-IsLink $item) {
                $target = Get-LinkTarget $item
                if ($target) { $cur = Resolve-RealPath $target ($Depth + 1) }
            }
        }
    }
    return $cur
}

# ---- manifest parsing ------------------------------------------------------

function ConvertTo-RelSpec {
    param([string] $Text)
    $t = $Text.Trim().Replace('\', '/')
    if ($t.StartsWith('./')) { $t = $t.Substring(2) }
    return $t.TrimStart('/').TrimEnd('/')
}

# Returns @{ Src; DestDir } or $null for blank / commented / invalid lines
function ConvertFrom-ManifestLine {
    param([string] $Line)
    $text = ($Line -replace '#.*$', '').Trim()
    if (-not $text) { return $null }

    $src = $text; $dest = ''
    $i = $text.IndexOf('|')
    if ($i -ge 0) {
        $src  = $text.Substring(0, $i)
        $dest = $text.Substring($i + 1)
    }
    $src  = ConvertTo-RelSpec $src
    $dest = ConvertTo-RelSpec $dest
    if ($dest -eq '.') { $dest = '' }

    if (-not $src) {
        Write-Status WARN "invalid manifest line: '$text'"
        return $null
    }
    return [pscustomobject]@{ Src = $src; DestDir = $dest }
}

# Paths (relative to the repo, with "/") that a manifest source stands for.
# A plain path is returned as is (even if missing, so callers can report it).
function Expand-Source {
    param([string] $Pattern)
    if (-not [WildcardPattern]::ContainsWildcardCharacters($Pattern)) { return @($Pattern) }

    $idx       = $Pattern.LastIndexOf('/')
    $parentRel = if ($idx -ge 0) { $Pattern.Substring(0, $idx) } else { '' }
    $leaf      = $Pattern.Substring($idx + 1)

    if ([WildcardPattern]::ContainsWildcardCharacters($parentRel)) {
        Write-Status WARN "wildcards are only supported in the last path segment: $Pattern"
        return @()
    }
    $parent = $DotfilesFull
    if ($parentRel) { $parent = Join-Path $DotfilesFull (ConvertTo-NativePath $parentRel) }
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) { return @() }

    $out = foreach ($child in (Get-ChildItem -LiteralPath $parent -Force | Sort-Object Name)) {
        if ($child.Name -like $leaf) {
            if ($parentRel) { "$parentRel/$($child.Name)" } else { $child.Name }
        }
    }
    return @($out | Where-Object { $_ })
}

function Get-SourcePath {
    param([string] $Rel)
    return Join-Path $DotfilesFull (ConvertTo-NativePath $Rel)
}

function Resolve-DestDir {
    param([string] $Dir)
    if (-not $Dir) { return $HomeFull }
    if ($Dir -eq '~' -or $Dir.StartsWith('~/')) { $Dir = $HomeFull + $Dir.Substring(1) }
    $Dir = ConvertTo-NativePath ([Environment]::ExpandEnvironmentVariables($Dir))
    if (-not [IO.Path]::IsPathRooted($Dir)) { $Dir = Join-Path $HomeFull $Dir }
    return [IO.Path]::GetFullPath($Dir)
}

function Get-EntryDest {
    param($Entry, [string] $Match)
    return Join-Path (Resolve-DestDir $Entry.DestDir) ([IO.Path]::GetFileName($Match))
}

function Test-ManifestHas {
    param([string] $Dest)
    if (-not (Test-Path -LiteralPath $Manifest -PathType Leaf)) { return $false }
    foreach ($line in @(Get-Content -LiteralPath $Manifest)) {
        $e = ConvertFrom-ManifestLine $line
        if (-not $e) { continue }
        foreach ($m in @(Expand-Source $e.Src)) {
            if (Test-SamePath (Get-EntryDest $e $m) $Dest) { return $true }
        }
    }
    return $false
}

function Add-ManifestEntry {
    param([string] $SrcRel, [string] $Dest)
    $rel = $Dest.Substring($HomeFull.Length + 1)

    if (Test-ManifestHas $Dest) {
        Write-Status MANIFEST "already lists $rel"
        return
    }

    $destDir = [IO.Path]::GetDirectoryName($rel)
    $entry = if ($destDir) { "$SrcRel|" + $destDir.Replace('\', '/') } else { $SrcRel }

    if ($DryRun) { Write-Status DRY "append to manifest: $entry"; return }

    $dir = Split-Path $Manifest -Parent
    if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $prefix = ''
    if (Test-Path -LiteralPath $Manifest -PathType Leaf) {
        $raw = [IO.File]::ReadAllText($Manifest)
        if ($raw.Length -gt 0 -and -not $raw.EndsWith("`n")) { $prefix = "`n" }
    }
    [IO.File]::AppendAllText($Manifest, $prefix + $entry + "`n", $Utf8NoBom)
    Write-Status MANIFEST "+ $entry"
}

# ---- linking ---------------------------------------------------------------

function New-Link {
    param([string] $Source, [string] $Dest)
    Invoke-Step "link $Dest -> $Source" {
        try {
            New-Item -ItemType SymbolicLink -Path $Dest -Target $Source | Out-Null
        } catch {
            if ($IsWin -and (Test-Path -LiteralPath $Source -PathType Container)) {
                New-Item -ItemType Junction -Path $Dest -Target $Source | Out-Null
                Write-Status INFO 'Symlink failed; created a junction instead.'
            } else {
                throw
            }
        }
    }
}

function Invoke-Link {
    param([string] $Source, [string] $Dest)

    if (-not (Test-Exists $Source)) {
        Write-Status MISSING "$Source (skipped)"
        $script:Missing++
        return
    }

    if ((Test-Exists $Dest) -and (Test-SamePath (Resolve-RealPath $Dest) (Resolve-RealPath $Source))) {
        Write-Status SKIP "$Dest (already linked)"
        $script:Skipped++
        return
    }

    try {
        $parent = Split-Path $Dest -Parent
        if (-not (Test-Path -LiteralPath $parent)) {
            Invoke-Step "mkdir $parent" { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        }

        if (Test-Exists $Dest) {
            $backup = "${Dest}.backup$Stamp"
            Invoke-Step "rename $Dest -> $backup" {
                Rename-Item -LiteralPath $Dest -NewName ([IO.Path]::GetFileName($backup))
            }
            Write-Status BACKUP "$Dest -> $backup"
            $script:BackedUp++
        }

        New-Link $Source $Dest
        Write-Status LINK "$Dest -> $Source"
        $script:Linked++
    } catch {
        $hint = if ($IsWin) { ' (symlinks need Administrator or Developer Mode)' } else { '' }
        Write-Status ERROR "$Dest : $($_.Exception.Message)$hint"
        $script:Failed++
    }
}

function Invoke-LinkAll {
    if (-not (Test-Path -LiteralPath $DotfilesFull -PathType Container)) {
        Write-Status ERROR "Dotfiles folder not found: $DotfilesFull"; exit 1
    }
    if (-not (Test-Path -LiteralPath $Manifest -PathType Leaf)) {
        Write-Status ERROR "Manifest not found: $Manifest"; exit 1
    }

    foreach ($line in @(Get-Content -LiteralPath $Manifest)) {
        $e = ConvertFrom-ManifestLine $line
        if (-not $e) { continue }

        $found = @(Expand-Source $e.Src)
        if ($found.Count -eq 0) {
            Write-Status MISSING "$(Get-SourcePath $e.Src) (no match, skipped)"
            $script:Missing++
            continue
        }
        foreach ($m in $found) {
            Invoke-Link (Get-SourcePath $m) (Get-EntryDest $e $m)
        }
    }

    Write-Host ''
    Write-Host "Done: $($script:Linked) linked, $($script:Skipped) skipped, $($script:BackedUp) backed up, $($script:Missing) missing, $($script:Failed) failed."
}

# ---- add mode --------------------------------------------------------------

function Invoke-Add {
    param([string] $InputPath)

    $abs = Get-FullPath $InputPath
    if (-not (Test-Exists $abs)) {
        Write-Status ERROR "$InputPath does not exist"; return $false
    }
    if ((Test-SamePath $abs $DotfilesFull) -or (Test-IsInside $abs $DotfilesFull)) {
        Write-Status ERROR "$abs is inside the dotfiles repo; pass the path under `$HOME"; return $false
    }
    if (-not (Test-IsInside $abs $HomeFull)) {
        Write-Status ERROR "$abs is not inside $HomeFull"; return $false
    }

    $rel      = $abs.Substring($HomeFull.Length + 1)
    $item     = Get-ItemSafe $abs
    $isLink   = Test-IsLink $item
    $resolved = Resolve-RealPath $abs

    # Already managed (link into the repo, or inside a linked directory)
    if (Test-IsInside $resolved $DotfilesReal) {
        if ($isLink) {
            Write-Status SKIP "$rel (already a link into the repo)"
            if ([IO.Path]::GetFileName($resolved) -ne [IO.Path]::GetFileName($abs)) {
                Write-Status WARN "link name differs from its source name; the manifest can't express that, not adding"
            } else {
                Add-ManifestEntry ($resolved.Substring($DotfilesReal.Length + 1).Replace('\', '/')) $abs
            }
        } else {
            Write-Status SKIP "$rel (already managed through a linked parent directory)"
        }
        return $true
    }

    if ($isLink) {
        Write-Status ERROR "$abs is a link pointing outside the repo; not adding it"; return $false
    }

    # Stored flat in the repo root: $DOTFILES\<basename>
    $name = [IO.Path]::GetFileName($abs)
    $src  = Join-Path $DotfilesFull $name
    if (Test-Exists $src) {
        Write-Status ERROR "$src already exists in the repo; rename or remove it first"; return $false
    }

    try {
        if (-not (Test-Path -LiteralPath $DotfilesFull)) {
            Invoke-Step "mkdir $DotfilesFull" { New-Item -ItemType Directory -Path $DotfilesFull -Force | Out-Null }
        }
        Invoke-Step "move $abs -> $src" { Move-Item -LiteralPath $abs -Destination $src }
        New-Link $src $abs
        Write-Status ADD "$abs -> $src"
        Add-ManifestEntry $name $abs
        return $true
    } catch {
        Write-Status ERROR "$abs : $($_.Exception.Message)"
        return $false
    }
}

# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------

if ($Help) { Show-Usage; exit 0 }

$Dotfiles = if ($env:DOTFILES) { $env:DOTFILES } else { Join-Path $HOME 'dotfiles' }
$HomeFull     = Get-FullPath $HOME
$DotfilesFull = Get-FullPath $Dotfiles
$DotfilesReal = Resolve-RealPath $DotfilesFull
if (-not $Manifest) { $Manifest = Join-Path $DotfilesFull 'MANIFEST.windows' }
$Manifest = Get-FullPath $Manifest

$paths = @(@($Add) + @($Rest) | Where-Object { $_ })

if ($PSBoundParameters.ContainsKey('Add')) {
    if ($paths.Count -eq 0) { Write-Status ERROR 'dot -a needs at least one path'; exit 1 }
    $allOk = $true
    foreach ($p in $paths) {
        if (-not (Invoke-Add $p)) { $allOk = $false }
    }
    if (-not $allOk) { exit 1 }
} elseif ($paths.Count -gt 0) {
    Write-Status ERROR "Unexpected arguments: $($paths -join ' ') (did you forget -a?)"; exit 1
} else {
    Invoke-LinkAll
    if ($script:Failed -gt 0) { exit 1 }
}
