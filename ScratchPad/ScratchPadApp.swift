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
            CommandGroup(replacing: .newItem) {
                Button("New Page") {
                    noteModel.appendNewNote()
                }.keyboardShortcut("n", modifiers: [.command])
            }
            
            CommandGroup(after: .newItem) {
                Button("Close") {
                    NSApplication.shared.keyWindow?.close()
                }.keyboardShortcut("w", modifiers: [.command])
            }
            
            CommandGroup(replacing: .saveItem) {
                Button("Delete Page") {
                    noteModel.deleteNote()
                }.keyboardShortcut(.delete, modifiers: [.command])
            }
            
            CommandGroup(replacing: .importExport) {
                Button("Export Page...") {
                    noteModel.exportNote()
                }
                
                Button("Import from Version 1...") {
                    commandsModel.importSheetOpen.toggle()
                }
            }
            
            CommandGroup(before: .windowList) {
                Button("Open Welcome Sheet...") {
                    commandsModel.welcomeSheetOpen.toggle()
                }
                
                Divider()
            }
            
            CommandMenu("Page") {
                Button("Previous Page") {
                    if noteModel.pageNumber > 1 {
                        noteModel.pageNumber -= 1
                    }
                }.keyboardShortcut(.leftArrow, modifiers: [.option, .command])
                
                Button("Next Page") {
                    noteModel.pageNumber += 1
                }.keyboardShortcut(.rightArrow, modifiers: [.option, .command])
            }
            
            TextEditingCommands()
            TextFormattingCommands()
            ToolbarCommands()
        }
        
        Settings {
            SettingsWindowView()
                .frame(width: 450)
                .environmentObject(settingsModel)
        }
    }
}
