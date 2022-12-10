//
//  ScratchPadCommands.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct ScratchPadCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: .newItem, addition: { })
        CommandGroup(after: CommandGroupPlacement.newItem) {
            Button("Import from Older Version...") {
                let importWindow = ImportWindowManager()
                importWindow.openWindow()
            }
        }
    }
}

