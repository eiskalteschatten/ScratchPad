//
//  CommandsModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import SwiftUI

final class CommandsModel: ObservableObject {
    @Published var importSheetOpen = false
    @Published var welcomeSheetOpen = false
}

