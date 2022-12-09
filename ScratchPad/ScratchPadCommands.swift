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
    }
}

