//
//  ScratchPadApp.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        
        let windowTransparency = UserDefaults.standard.value(forKey: "windowTransparency") as? Double ?? 100
        NSApp.windows.first?.isOpaque = windowTransparency == 100
        NSApp.windows.first?.alphaValue = windowTransparency / 100
        
        let floatAboveOtherWindows = UserDefaults.standard.bool(forKey: "floatAboveOtherWindows")
        NSApp.windows.first?.level = floatAboveOtherWindows ? .popUpMenu : .normal
    }
}

@main
struct ScratchPadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject private var noteModel = NoteModel()
    @ObservedObject private var settingsModel = SettingsModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(noteModel)
                .environmentObject(settingsModel)
        }
        .commands {
            ScratchPadCommands()
            TextEditingCommands()
            TextFormattingCommands()
        }
        
        Settings {
            SettingsWindowView()
                .frame(width: 450)
        }
    }
}
