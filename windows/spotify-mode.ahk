#Requires AutoHotkey v2.0
#SingleInstance Force

; Initialize the Spotify mode variable to false (off)
global spotifyMode := false

; -----------------------------------------------------------------
; ENTERING THE SUBMODE
; -----------------------------------------------------------------
; Super + Alt + V (#!v) enters the "spotify-submap" equivalent
#!v:: {
    global spotifyMode := true
    ToolTip("Spotify Mode: ON") ; Visual cue that you entered the mode
    SetTimer(() => ToolTip(), -2000) ; Hides the tooltip after 2 seconds
}

; -----------------------------------------------------------------
; SPOTIFY MODE HOTKEYS
; -----------------------------------------------------------------
#HotIf spotifyMode

; Shift + j : Volume Down
+j:: {
    Run("playerctl -p spotify volume 0.05-", , "Hide") ; If using a CLI tool, or use native media keys:
    ; Send("{Volume_Down}") 
}

; Shift + k : Volume Up
+k:: {
    Run("playerctl -p spotify volume 0.05+", , "Hide")
    ; Send("{Volume_Up}")
}

; p : Play / Pause
p::Send("{Media_Play_Pause}")

; n : Next Track
n::Send("{Media_Next}")

; Shift + n : Previous Track
+n::Send("{Media_Prev}")

; / : Focus Spotify and send Ctrl+K (Search)
/:: {
    if WinExist("ahk_exe Spotify.exe") {
        WinActivate("ahk_exe Spotify.exe")
        Send("^k")
    }
}

; -----------------------------------------------------------------
; EXITING THE SUBMODE (Reset keys)
; -----------------------------------------------------------------
Escape::
i::
a::
+i::
+a::
#!v:: {
    global spotifyMode := false
    ToolTip("Spotify Mode: OFF")
    SetTimer(() => ToolTip(), -1000)
}

#HotIf ; Ends the conditional hotkey block
