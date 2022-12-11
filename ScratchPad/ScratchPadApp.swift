//
//  ScratchPadApp.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import AppKit
import SwiftUI
import Sparkle

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
    
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(noteModel)
                .environmentObject(settingsModel)
                .environmentObject(commandsModel)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updater: updaterController.updater)
            }
            
            CommandGroup(replacing: .newItem) { }
            
            CommandGroup(replacing: .saveItem) {
                Button("Delete Page") {
                    noteModel.deleteNote()
                }.keyboardShortcut(.delete, modifiers: [.command])
            }
            
            CommandGroup(replacing: .importExport) {
                Button("Export Page...") {
                    noteModel.exportNote()
                }
                
                Divider()
                
                Button("Import from Version 1.x...") {
                    commandsModel.importSheetOpen.toggle()
                }
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
        }
    }
}
