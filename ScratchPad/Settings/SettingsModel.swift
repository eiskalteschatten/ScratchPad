//
//  SettingsModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

final class SettingsModel: ObservableObject {
    private var storageLocationModel: StorageLocationModel
    
    @Published var windowTransparency = ScratchPadUserDefaults.defaults.value(forKey: ScratchPadUserDefaults.windowTransparency) as? Double ?? 100 {
        didSet {
            ScratchPadUserDefaults.defaults.set(windowTransparency, forKey: ScratchPadUserDefaults.windowTransparency)
            NSApp.windows.first?.isOpaque = windowTransparency == 100
            NSApp.windows.first?.alphaValue = windowTransparency / 100
        }
    }

    @Published var floatAboveOtherWindows = ScratchPadUserDefaults.defaults.bool(forKey: ScratchPadUserDefaults.floatAboveOtherWindows) {
        didSet {
            ScratchPadUserDefaults.defaults.set(floatAboveOtherWindows, forKey: ScratchPadUserDefaults.floatAboveOtherWindows)
            NSApp.windows.first?.level = floatAboveOtherWindows ? .popUpMenu : .normal
        }
    }
    
    init(storageLocationModel: StorageLocationModel) {
        self.storageLocationModel = storageLocationModel
    }
}
