//
//  SettingsModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

final class SettingsModel: ObservableObject {
    private var storageLocationModel: StorageLocationModel
    
    @Published var windowTransparency = UserDefaults.standard.value(forKey: "windowTransparency") as? Double ?? 100 {
        didSet {
            UserDefaults.standard.set(windowTransparency, forKey: "windowTransparency")
            NSApp.windows.first?.isOpaque = windowTransparency == 100
            NSApp.windows.first?.alphaValue = windowTransparency / 100
        }
    }

    @Published var floatAboveOtherWindows = UserDefaults.standard.bool(forKey: "floatAboveOtherWindows") {
        didSet {
            UserDefaults.standard.set(floatAboveOtherWindows, forKey: "floatAboveOtherWindows")
            NSApp.windows.first?.level = floatAboveOtherWindows ? .popUpMenu : .normal
        }
    }
    
    init(storageLocationModel: StorageLocationModel) {
        self.storageLocationModel = storageLocationModel
    }
}
