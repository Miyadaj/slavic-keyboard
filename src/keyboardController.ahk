﻿#SingleInstance Force
A_IconTip := "Main Controller"
TraySetIcon("icon\main.ico",,false)
DetectHiddenWindows(true)

scriptA := "keyboard_cyrl.ahk"
scriptB := "keyboard_latn.ahk"
scriptC := "keyboard_cyrs.ahk"
scriptD := "keyboard_glag.ahk"
currentScript := false
HKModern := IniRead("config\config.ini", "Hotkey", "ModernSlavicKeyboard", "^1")
HKChurch := IniRead("config\config.ini", "Hotkey", "ChurchSlavonicKeyboard", "^2")

Hotkey(HKModern,ModernKB,"On")
Hotkey(HKChurch,ChurchKB,"On")

F6::Reload
switchKeyboard(new,old) {
    global
    SetTimer(ToolTip,-1500)
    if old = HKModern {
        ToolTip("Loading Church Slavonic keyboard...")
        if WinExist(scriptA)
            WinClose(scriptA)
        if WinExist(scriptB)
            WinClose(scriptB)
    }
    else if old = HKChurch {
        ToolTip("Loading Modern Slavic keyboard...")
        if WinExist(scriptC)
            WinClose(scriptC)
        if WinExist(scriptD)
            WinClose(scriptD)
    }
    currentScript := false
    Sleep 2000
    Send new
}

ModernKB(*) {
    global
    if !currentScript {
        Run(scriptA)
        currentScript := true
        SetTimer(ToolTip,-1500)
        ToolTip("Slavic Cyrillic")
    }
    else if WinExist(scriptA, , "Visual Studio Code") {
        WinClose(scriptA)
        Run(scriptB)
        currentScript := true
        SetTimer(ToolTip,-1500)
        ToolTip("Slavic Latin")
    }
    else if WinExist(scriptB) {
        WinClose(scriptB)
        currentScript := false
        SetTimer(ToolTip,-1500)
        ToolTip("Exiting keyboard mode...")
    }
    else {
        switchKeyboard(HKModern,HKChurch)
    }
}

ChurchKB(*) {
    global
    if !currentScript {
        Run(scriptC, , , &pidC)
        currentScript := true
        SetTimer(ToolTip,-1500)
        ToolTip("Early Cyrillic")
    }
    else if WinExist(scriptC) {
        WinClose(scriptC)
        Run(scriptD)
        currentScript := true
        SetTimer(ToolTip,-1500)
        ToolTip("Glagolitic")
    }
    else if WinExist(scriptD) {
        WinClose(scriptD)
        currentScript := false
        SetTimer(ToolTip,-1500)
        ToolTip("Exiting keyboard mode...")
    }
    else {
        switchKeyboard(HKChurch,HKModern)
    }
}