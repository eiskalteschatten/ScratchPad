//
//  SettingsModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

final class SettingsModel: ObservableObject {
    private var storageLocationModel: StorageLocationModel
    
    @Published var windowTransparency = ScratchBookUserDefaults.defaults.value(forKey: ScratchBookUserDefaults.windowTransparency) as? Double ?? 100 {
        didSet {
            ScratchBookUserDefaults.defaults.set(windowTransparency, forKey: ScratchBookUserDefaults.windowTransparency)
            NSApp.windows.first?.isOpaque = windowTransparency == 100
            NSApp.windows.first?.alphaValue = windowTransparency / 100
        }
    }

    @Published var floatAboveOtherWindows = ScratchBookUserDefaults.defaults.bool(forKey: ScratchBookUserDefaults.floatAboveOtherWindows) {
        didSet {
            ScratchBookUserDefaults.defaults.set(floatAboveOtherWindows, forKey: ScratchBookUserDefaults.floatAboveOtherWindows)
            NSApp.windows.first?.level = floatAboveOtherWindows ? .popUpMenu : .normal
        }
    }
    
    init(storageLocationModel: StorageLocationModel) {
        self.storageLocationModel = storageLocationModel
    }
}
