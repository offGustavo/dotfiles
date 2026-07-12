#Requires -Version 5.1
<#
.SYNOPSIS
    Creates symbolic links from a dotfiles repository to their expected system locations.
.DESCRIPTION
    Declare your mappings in the $Mappings array below.
    Each entry has:
        path_in_dots  - path relative to $DotsRoot (the repo)
        window_path   - absolute destination path (supports ~ and environment variables)
    The script will:
        - Expand all paths
        - Skip a mapping if the source does not exist
        - Back up an existing file/directory at the destination before replacing it
        - Create any missing parent directories
        - Create a symlink (file or junction for directories)
.NOTES
    Run as Administrator - creating symlinks on Windows requires elevated privileges
    (or Developer Mode enabled in Settings > For developers).
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string] $DotsRoot = $PSScriptRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# CONFIGURATION
# ---------------------------------------------------------------------------

# TODO: add a custom variable to make path correct here
$Mappings = @(
    @{
        path_in_dots = '../.config/nvim'
        window_path  = "$env:LOCALAPPDATA\nvim"
    }
    @{
        path_in_dots = '../.config/doom'
        window_path  = '~\.doom.d'
    }
    @{
        path_in_dots = '../.emacs'
        window_path  = '~\.emacs'
    }
    # @{
    #     path_in_dots = '../.vimrc'
    #     window_path  = '~\_vimrc'
    # }
    @{
        path_in_dots = '../.wezterm.lua'
        window_path  = '~\.wezterm.lua'
    }
    # Add more mappings below:
    @{
        path_in_dots = '../.gitconfig'
        window_path  = '~\.gitconfig'
    }
)

# ---------------------------------------------------------------------------
# HELPERS
# ---------------------------------------------------------------------------

function Expand-PathFull {
    param([string] $Path)
    if ($Path.StartsWith('~')) {
        $Path = $Path.Replace('~', $HOME)
    }
    $Path = [System.Environment]::ExpandEnvironmentVariables($Path)
    return $Path
}

function Write-Status {
    param(
        [ValidateSet('OK','SKIP','BACKUP','ERROR','INFO')] [string] $Tag,
        [string] $Message
    )
    $colours = @{
        OK     = 'Green'
        SKIP   = 'Yellow'
        BACKUP = 'Cyan'
        ERROR  = 'Red'
        INFO   = 'Gray'
    }
    $prefix = "[$Tag]".PadRight(8)
    Write-Host $prefix -ForegroundColor $colours[$Tag] -NoNewline
    Write-Host " $Message"
}

function Backup-Existing {
    param([string] $Path)
    $timestamp  = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupPath = "${Path}.bak.${timestamp}"
    Rename-Item -LiteralPath $Path -NewName $backupPath
    Write-Status BACKUP "Existing item backed up -> $backupPath"
}

function New-Symlink {
    param(
        [string] $TargetPath,
        [string] $LinkPath
    )
    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath | Out-Null
}

# ---------------------------------------------------------------------------
# PRIVILEGE CHECK
# ---------------------------------------------------------------------------

$currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Status INFO 'Not running as Administrator.'
    Write-Status INFO 'Symlink creation may fail unless Developer Mode is enabled.'
    Write-Status INFO 'Re-run from an elevated PowerShell prompt if you see errors.'
    Write-Host ''
}

# ---------------------------------------------------------------------------
# MAIN LOOP
# ---------------------------------------------------------------------------

Write-Host ''
Write-Host '  Dotfile Symlinker' -ForegroundColor White
Write-Host "  Repo root : $DotsRoot"
Write-Host ''

$ok = 0; $skipped = 0; $failed = 0

foreach ($mapping in $Mappings) {
    $sourcePath = Join-Path $DotsRoot $mapping.path_in_dots
    $destPath   = Expand-PathFull $mapping.window_path

    Write-Host "  $($mapping.path_in_dots) -> $destPath" -ForegroundColor DarkGray

    # 1. Verify source exists
    if (-not (Test-Path -LiteralPath $sourcePath)) {
        Write-Status SKIP "Source not found: $sourcePath"
        $skipped++
        Write-Host ''
        continue
    }

    # 2. Already a correct symlink?
    if (Test-Path -LiteralPath $destPath) {
        $item = Get-Item -LiteralPath $destPath -Force
        if ($item.LinkType -in 'SymbolicLink','Junction') {
            $target = $item.Target
            if ($target -eq $sourcePath) {
                Write-Status OK "Symlink already correct - nothing to do."
                $ok++
                Write-Host ''
                continue
            } else {
                Write-Status INFO "Existing symlink points elsewhere ($target). Replacing."
                Remove-Item -LiteralPath $destPath -Force -Recurse
            }
        } else {
            Backup-Existing $destPath
            Remove-Item -LiteralPath $destPath -Force -Recurse
        }
    }

    # 3. Ensure parent directory exists
    $parentDir = Split-Path $destPath -Parent
    if (-not (Test-Path -LiteralPath $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        Write-Status INFO "Created parent directory: $parentDir"
    }

    # 4. Create the symlink
    try {
        if ($PSCmdlet.ShouldProcess($destPath, "Create symlink -> $sourcePath")) {
            New-Symlink -TargetPath $sourcePath -LinkPath $destPath
            Write-Status OK "Linked."
            $ok++
        }
    } catch {
        Write-Status ERROR "Failed: $_"
        $failed++
    }

    Write-Host ''
}

# ---------------------------------------------------------------------------
# SUMMARY
# ---------------------------------------------------------------------------

Write-Host '  -------------------------------------'
Write-Host "  Done.  OK: $ok   Skipped: $skipped   Failed: $failed"
Write-Host '  -------------------------------------'
Write-Host ''

