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
    
    @ObservedObject private var storageLocationModel: StorageLocationModel
    @ObservedObject private var settingsModel: SettingsModel
    @ObservedObject private var noteModel: NoteModel
    @ObservedObject private var commandsModel: CommandsModel
    
    @State private var importScreenOpen = false
    
    init() {
        /// Note: The order here is critical. StorageLocationModel always needs to be initialized first so that the storageLocation is set and checked correctly!
        let storageLocationModel = StorageLocationModel()
        _storageLocationModel = ObservedObject(wrappedValue: storageLocationModel)
        _settingsModel = ObservedObject(wrappedValue: SettingsModel(storageLocationModel: storageLocationModel))
        _noteModel = ObservedObject(wrappedValue: NoteModel(storageLocationModel: storageLocationModel))
        _commandsModel = ObservedObject(wrappedValue: CommandsModel())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storageLocationModel)
                .environmentObject(noteModel)
                .environmentObject(settingsModel)
                .environmentObject(commandsModel)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Page", systemImage: "plus") {
                    noteModel.appendNewNote()
                }.keyboardShortcut("n", modifiers: [.command])
            }
            
            CommandGroup(after: .newItem) {
                Button("Close", systemImage: "xmark") {
                    NSApplication.shared.keyWindow?.close()
                }.keyboardShortcut("w", modifiers: [.command])
            }
            
            CommandGroup(replacing: .saveItem) {
                Button("Delete Page", systemImage: "trash") {
                    noteModel.deleteNote()
                }.keyboardShortcut(.delete, modifiers: [.command])
            }
            
            CommandGroup(replacing: .importExport) {
                Button("Export Page...", systemImage: "square.and.arrow.up") {
                    noteModel.exportNote()
                }
                
                Button("Import from Version 1...", systemImage: "square.and.arrow.down") {
                    commandsModel.importSheetOpen.toggle()
                }
            }
            
            CommandGroup(before: .windowList) {
                Button("Open Welcome Sheet...", systemImage: "star") {
                    commandsModel.welcomeSheetOpen.toggle()
                }
                
                Divider()
            }
            
            CommandMenu("Go") {
                Button("First Page", systemImage: "chevron.backward.to.line") {
                    noteModel.goToFirstPage()
                }.keyboardShortcut(.leftArrow, modifiers: [.option, .shift, .command])
                
                Button("Previous Page", systemImage: "chevron.left") {
                    if noteModel.pageNumber > 1 {
                        noteModel.pageNumber -= 1
                    }
                }.keyboardShortcut(.leftArrow, modifiers: [.option, .command])
                
                Button("Next Page", systemImage: "chevron.right") {
                    noteModel.pageNumber += 1
                }.keyboardShortcut(.rightArrow, modifiers: [.option, .command])
                
                Button("Last Page", systemImage: "chevron.forward.to.line") {
                    noteModel.goToLastPage()
                }.keyboardShortcut(.rightArrow, modifiers: [.option, .shift, .command])
            }
            
            TextEditingCommands()
            TextFormattingCommands()
            ToolbarCommands()
        }
        
        Settings {
            SettingsWindowView()
                .frame(minWidth: 450)
                .fixedSize()
                .environmentObject(settingsModel)
                .environmentObject(storageLocationModel)
        }
    }
}
