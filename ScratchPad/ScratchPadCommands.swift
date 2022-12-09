//
//  ScratchPadCommands.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct ScratchPadCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: CommandGroupPlacement.appSettings) {
            Button("Settings...") {
                let settingsWindow = SettingsWindowManager()
                settingsWindow.openWindow()
            }
            .keyboardShortcut(",", modifiers: [.command])
        }
    }
}

