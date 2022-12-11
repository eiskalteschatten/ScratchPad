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

    @ObservedObject private var settingsModel = SettingsModel()
    @ObservedObject private var noteModel = NoteModel()
    @ObservedObject private var commandsModel = CommandsModel()
    
    @State private var importScreenOpen = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(noteModel)
                .environmentObject(settingsModel)
                .environmentObject(commandsModel)
        }
        .commands {
            CommandGroup(replacing: .newItem) { }
            
            CommandGroup(replacing: .importExport) {
                Button("Import from Version 1.x...") {
                    commandsModel.importSheetOpen.toggle()
                }
            }
            
            TextEditingCommands()
            TextFormattingCommands()
        }
        
        Settings {
            SettingsWindowView()
                .frame(width: 450)
        }
    }
}
