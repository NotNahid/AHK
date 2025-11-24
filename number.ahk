#Requires AutoHotkey v2.0
#SingleInstance Force

; =======================================================
; 📞 BD NUMBER FORMATTER (STRICT LENGTH CHECK)
; Only converts if result is exactly 11 digits (01xxxxxxxxx)
; =======================================================

$^c:: 
{
    A_Clipboard := "" 
    Send "^c"         
    
    if !ClipWait(1)   
        return 

    Text := A_Clipboard

    ; Check if it starts with the BD code
    if RegExMatch(Text, "^\s*\+880[\d\-\s]+\s*$")
    {
        ; 1. Clean the number
        NewText := StrReplace(Text, "+880", "0")
        NewText := StrReplace(NewText, "-", "")
        NewText := StrReplace(NewText, " ", "")

        ; 2. 📏 STRICT LENGTH CHECK
        ; BD Mobile numbers are 11 digits (e.g., 01700000000)
        ; If it's not 11 digits, it might be an ID or Math -> Don't touch it!
        if (StrLen(NewText) == 11)
        {
            A_Clipboard := NewText
            ToolTip("✅ Cleaned: " . NewText)
            SetTimer () => ToolTip(), -1500
        }
    }
}
