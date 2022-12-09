//
//  ScratchPadApp.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

@main
struct ScratchPadApp: App {
    @ObservedObject private var noteModel = NoteModel()
    @ObservedObject private var settingsModel = SettingsModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(noteModel)
                .environmentObject(settingsModel)
        }
        .commands {
//            ScratchPadCommands()
            TextEditingCommands()
            TextFormattingCommands()
        }
        
        Settings {
            SettingsWindowView()
                .frame(width: 450)
        }
    }
}
