//
//  SettingsModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

final class SettingsModel: ObservableObject {
    private var storageLocationModel: StorageLocationModel
    
    @Published var windowTransparency = UserDefaultsConfig.defaults.value(forKey: UserDefaultsConfig.windowTransparency) as? Double ?? 100 {
        didSet {
            UserDefaultsConfig.defaults.set(windowTransparency, forKey: UserDefaultsConfig.windowTransparency)
            NSApp.windows.first?.isOpaque = windowTransparency == 100
            NSApp.windows.first?.alphaValue = windowTransparency / 100
        }
    }

    @Published var floatAboveOtherWindows = UserDefaultsConfig.defaults.bool(forKey: UserDefaultsConfig.floatAboveOtherWindows) {
        didSet {
            UserDefaultsConfig.defaults.set(floatAboveOtherWindows, forKey: UserDefaultsConfig.floatAboveOtherWindows)
            NSApp.windows.first?.level = floatAboveOtherWindows ? .popUpMenu : .normal
        }
    }
    
    init(storageLocationModel: StorageLocationModel) {
        self.storageLocationModel = storageLocationModel
    }
}
