#Requires AutoHotkey v2.0
#SingleInstance Force

; =======================================================
; 🚀 APP LAUNCHERS & WEBSITES
; =======================================================

; 🧠 SMART F1: Search Selected Text OR Open Google
F1::
{
    OldClip := A_Clipboard
    A_Clipboard := "" ; Clear clipboard to detect change
    Send "^c" ; Try to copy highlighted text
    
    if ClipWait(0.3) ; Wait 0.3s to see if text was copied
    {
        ; ✅ Text WAS selected -> Search it
        Run "https://www.google.com/search?q=" . A_Clipboard
        Sleep 500 
        A_Clipboard := OldClip ; Restore original clipboard
    }
    else
    {
        ; ❌ NO text selected -> Open Google Home
        A_Clipboard := OldClip ; Restore clipboard
        Run("https://www.google.com", , "max")
    }
}

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
F7::Run("https://myaccount.google.com/u/1/security")
F8::Run("https://drive.google.com")

; Alt + Key Shortcuts
!y::Run("https://www.youtube.com")
!d::Run('explorer.exe "C:\Users\ASUS\Downloads"')
!g::Run("https://github.com")
!e::Run('"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"')
!c::Run("https://www.canva.com")
!w::Run("https://docs.google.com/document/u/0/")


; =======================================================
; ❓ CHEAT SHEET (F12)
; =======================================================
!q::
{
    MsgBox("
    (
    🚀 LAUNCHERS
    F1                - Google (Home OR Search Selected)
    F2 - F8           - Apps & Webs
    
    ✍️ TEXT TOOLS
    Ctrl+Shift+V      - Pure Paste (No Formatting)
    Alt + T           - Cycle Case (Upper/Lower)
    Type ';date'      - Insert YYYY-MM-DD
    Type '@@'         - Insert Email

    🛠️ POWER TOOLS
    Alt + S           - Screen Search (Lens)
    Ctrl + Space      - Pin Window (On Top)
    Win + Scroll      - Ghost Mode (Transparency)
    Alt + M           - Window Shade (Roll Up)
    
    🖱️ MOUSE TRICKS
    Alt + L-Click     - Drag Window
    Alt + R-Click     - Resize Window
    Mid-Click (Top)   - Close (Safe for Chrome)
    Scroll (Taskbar)  - Volume Control
    )", "My AHK Shortcuts", "Iconi")
}


; =======================================================
; ✍️ TEXT MANIPULATION TOOLS
; =======================================================

; 🧹 PURE PASTE (Strip Formatting) - Ctrl + Shift + V
^+v::
{
    A_Clipboard := A_Clipboard ; Converting to itself strips formatting
    Send "^v"
}

; 🔄 TEXT CASE CYCLER (Highlight -> Alt + T)
!t::
{
    OldClip := A_Clipboard
    A_Clipboard := ""
    Send "^c"
    if !ClipWait(0.5) {
        A_Clipboard := OldClip
        return
    }
    Str := A_Clipboard
    if (Str = StrUpper(Str))
        NewStr := StrLower(Str)
    else if (Str = StrLower(Str))
        NewStr := StrTitle(Str)
    else
        NewStr := StrUpper(Str)
    A_Clipboard := NewStr
    Send "^v"
    Sleep 100
    A_Clipboard := OldClip
}

; 📅 TEXT EXPANSION
:*:;date:: ; Type ";date"
{
    Send FormatTime(, "yyyy-MM-dd")
}
:*:@@::myemailaddress@gmail.com ; Type "@@" for email


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
        Send "{Tab}"
        Sleep 50
        Send "{Tab}" 
        Sleep 50
        Send "{Enter}" ; Open upload box
        Sleep 500
        Send "^v" ; Paste image
    }
}


; =======================================================
; 📌 WINDOW PINNING (Always On Top) - Ctrl + Space
; =======================================================
^Space:: 
{
    if WinGetExStyle("A") & 0x8 
    {
        WinSetAlwaysOnTop 0, "A" 
        SoundBeep 500, 200       
    }
    else
    {
        WinSetAlwaysOnTop 1, "A" 
        SoundBeep 1000, 200      
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
    try PostMessage(0xA1, 17, , , "A") 
}


; =======================================================
; ✅ ROBUST LAZY CLOSE (Middle Click Title Bar)
; ⛔ EXCLUDES CHROME
; =======================================================
~MButton::
{
    CoordMode "Mouse", "Screen" 
    MouseGetPos &X, &Y, &WinID
    
    try {
        if WinGetProcessName("ahk_id " WinID) = "chrome.exe"
            return
    }
    if WinGetClass("ahk_id " WinID) = "Shell_TrayWnd"
        return

    try {
        MessageResult := SendMessage(0x84, 0, (Y << 16) | (X & 0xFFFF), , "ahk_id " WinID)
    } catch {
        return
    }

    if (MessageResult == 2)
        PostMessage(0x112, 0xF060, , , "ahk_id " WinID)
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
