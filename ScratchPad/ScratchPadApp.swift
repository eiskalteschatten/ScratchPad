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
    
    var body: some Scene {
        WindowGroup {
            ContentView(noteModel: noteModel)
        }
        .commands {
            ScratchPadCommands()
            TextEditingCommands()
            TextFormattingCommands()
        }
    }
}
