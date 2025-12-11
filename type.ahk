; =======================================================
; ⌨️ MANUAL GHOST TYPER (Alt + Shift + T)
; =======================================================
!+t::
{
    ; 1. Create a nice Dark Mode GUI
    MyGui := Gui(, "Ghost Typer")
    MyGui.SetFont("s10", "Consolas") ; Monospace font looks cooler
    
    MyGui.Add("Text",, "Enter text to type manually:")
    
    ; A large box to type/paste your text
    TxtBox := MyGui.Add("Edit", "w400 h200 vMyText") 
    
    ; The "GO" button
    Btn := MyGui.Add("Button", "w400 h40 Default", "🚀 START TYPING (3s Delay)")
    
    ; When button is clicked, run the typing function
    Btn.OnEvent("Click", (*) => StartTyping(MyGui, TxtBox.Value))
    
    MyGui.Show()
}

StartTyping(GuiObj, TextToType)
{
    GuiObj.Destroy() ; Close the popup
    
    if (TextToType = "")
        return

    ; 2. The Countdown (Gives you time to focus the target)
    Loop 3
    {
        ToolTip "⏳ CLICK TARGET WINDOW! Typing in " . (4 - A_Index) . "..."
        SoundBeep 750, 100
        Sleep 1000
    }
    
    ToolTip "🚀 TYPING NOW..."
    
    ; 3. The Typing Logic
    ; SetKeyDelay: 10ms press duration, 10ms delay between keys
    ; This simulates super-fast human typing
    SetKeyDelay 10, 10 
    
    ; {Raw} means special chars like ! or ^ are typed as text, not treated as Alt/Ctrl
    SendEvent "{Raw}" . TextToType
    
    ToolTip ; Clear Tooltip
    SoundBeep 1000, 200
}