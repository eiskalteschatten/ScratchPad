//
//  ScratchPadCommands.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct ScratchPadCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: .newItem) { }
        
        CommandGroup(replacing: .importExport) {
            Button("Import from Older Version...") {
                let importWindow = ImportWindowManager()
                importWindow.openWindow()
            }
        }
    }
}

