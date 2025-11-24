#Requires AutoHotkey v2.0
#SingleInstance Force

; =======================================================
; 🚀 APP LAUNCHERS & WEBSITES
; =======================================================



F1::Run("https://www.google.com", , "max")




F2::Run("https://chat.openai.com", , "max")

; Smart Gemini Launch (Switch to tab if open, otherwise run)
F3::
{
    if WinExist("Gemini - Google Chrome") 
        WinActivate() 
    else
        Run("https://gemini.google.com", , "max") 
}

F4::Run('"C:\Program Files\Notepad++\notepad++.exe"')
F6::Run("https://mail.google.com", , "max")
F7::Run("https://myaccount.google.com/u/1/security") ; Changed Send to Run for better reliability
F8::Run("https://drive.google.com")

; Alt + Key Shortcuts
!y::Run("https://www.youtube.com")
!d::Run('explorer.exe "C:\Users\ASUS\Downloads"')
!g::Run("https://github.com")
!e::Run('"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"')
!c::Run("https://www.canva.com")
!w::Run("https://docs.google.com/document/u/0/")


; =======================================================
; 🔍 SCREEN SEARCH (Google Lens Style) - Alt + S
; =======================================================
!s::
{
    A_Clipboard := ""
    Send "#+s" ; Open Snipping Tool
    if !ClipWait(30, 1)
        return

    Run "https://google.com/imghp"
    
    if WinWaitActive("Google Images", , 5) 
    {
        Sleep 1000 ; Wait for load

        ; Tab navigation to find the Camera/Upload button
        Send "{Tab}"
        Sleep 50
        Send "{Tab}" 
        Sleep 50
        Send "{Enter}" ; Open the upload box
        
        Sleep 500
        Send "^v" ; Paste image
    }
}


; =======================================================
; 📌 WINDOW PINNING (Always On Top) - Ctrl + Space
; =======================================================
^Space:: 
{
    if WinGetExStyle("A") & 0x8 ; Checks if it is already "Always On Top"
    {
        WinSetAlwaysOnTop 0, "A" ; Turn it OFF
        SoundBeep 500, 200       ; Low beep
    }
    else
    {
        WinSetAlwaysOnTop 1, "A" ; Turn it ON
        SoundBeep 1000, 200      ; High beep
    }
}


; =======================================================
; 👻 ADVANCED GHOST MODE (Win + Scroll)
; =======================================================
#WheelDown:: ; Fade Out
{
    try {
        CurrentOpacity := WinGetTransparent("A")
        if (CurrentOpacity = "")
            CurrentOpacity := 255
    } catch {
        return
    }

    NewOpacity := CurrentOpacity - 25
    if (NewOpacity < 30)
        NewOpacity := 30

    WinSetTransparent NewOpacity, "A"
    ShowOpacityTooltip(NewOpacity)
}

#WheelUp:: ; Fade In
{
    try {
        CurrentOpacity := WinGetTransparent("A")
        if (CurrentOpacity = "")
            CurrentOpacity := 255
    } catch {
        return
    }

    NewOpacity := CurrentOpacity + 25

    if (NewOpacity >= 255) {
        WinSetTransparent "Off", "A"
        ShowOpacityTooltip(255)
    } else {
        WinSetTransparent NewOpacity, "A"
        ShowOpacityTooltip(NewOpacity)
    }
}

ShowOpacityTooltip(level)
{
    Percentage := Round((level / 255) * 100)
    ToolTip "Opacity: " . Percentage . "%"
    SetTimer () => ToolTip(), -1000 
}


; =======================================================
; 🖱️ EASY WINDOW DRAG & RESIZE (Alt + Click)
; =======================================================

!LButton:: ; Alt + Left Click to DRAG
{
    try PostMessage(0xA1, 2, , , "A")
}

!RButton:: ; Alt + Right Click to RESIZE (Native)
{
    ; 0xA1 = Non-Client Click, 17 = Bottom-Right Corner
    try PostMessage(0xA1, 17, , , "A") 
}

; =======================================================
; ✅ ROBUST LAZY CLOSE (Middle Click Title Bar)
; ⛔ EXCLUDES CHROME
; =======================================================
#Requires AutoHotkey v2.0

~MButton::
{
    ; Get Mouse position in SCREEN coordinates (essential for HitTest)
    CoordMode "Mouse", "Screen" 
    MouseGetPos &X, &Y, &WinID
    
    ; -------------------------------------------------------
    ; 🛑 EXCEPTION: If Chrome, stop here.
    ; This lets the native Middle Click close your tabs.
    ; -------------------------------------------------------
    try {
        if WinGetProcessName("ahk_id " WinID) = "chrome.exe"
            return
    }

    ; If the mouse is over the taskbar, do nothing (optional safety)
    if WinGetClass("ahk_id " WinID) = "Shell_TrayWnd"
        return

    ; Send WM_NCHITTEST (0x84) to ask the window what is under the cursor
    ; We pass the X and Y coordinates packed into the LPARAM
    try 
    {
        MessageResult := SendMessage(0x84, 0, (Y << 16) | (X & 0xFFFF), , "ahk_id " WinID)
    }
    catch
    {
        return ; Handle cases where permission is denied (e.g., Admin windows)
    }

    ; Check if the result is 2 (HTCAPTION), which means "Title Bar"
    if (MessageResult == 2)
    {
        ; Send SC_CLOSE (0xF060) via WM_SYSCOMMAND (0x112)
        PostMessage(0x112, 0xF060, , , "ahk_id " WinID)
    }
}

; =======================================================
; 🔊 SONIC SCROLL (Hover Taskbar -> Volume)
; =======================================================
#HotIf MouseIsOver("ahk_class Shell_TrayWnd") 

WheelUp::Send "{Volume_Up}"     
WheelDown::Send "{Volume_Down}" 
MButton::Send "{Volume_Mute}"   

#HotIf 

MouseIsOver(WinTitle) 
{
    MouseGetPos , , &Win
    return WinExist(WinTitle . " ahk_id " . Win)
}


; =======================================================
; 📜 WINDOW SHADE (Alt + M to Roll Up)
; =======================================================
WindowHeights := Map()

!m:: 
{
    WinID := WinExist("A") 
    
    if WindowHeights.Has(WinID) 
    {
        WinMove , , , WindowHeights[WinID], "ahk_id " . WinID
        WindowHeights.Delete(WinID) 
    }
    else 
    {
        WinGetPos , , , &H, "ahk_id " . WinID 
        WindowHeights[WinID] := H 
        WinMove , , , 30, "ahk_id " . WinID 
    }
}

