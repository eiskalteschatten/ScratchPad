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
    
    @Published var formattedStorageLocation: String?
    
    init(storageLocationModel: StorageLocationModel) {
        self.storageLocationModel = storageLocationModel
        setFormattedStorageLocation()
    }
    
    func resetStorageLocation() {
        storageLocationModel.resetStorageLocation()
        setFormattedStorageLocation()
    }
    
    private func setFormattedStorageLocation() {
        if storageLocationModel.usesDefaultStorageLocation {
            formattedStorageLocation = String(localized: "Default Location", comment: "")
        }
        else {
            guard let locationString = storageLocationModel.storageLocation?.absoluteString else { return }
            formattedStorageLocation = locationString.replacingOccurrences(of: "file://", with: "")
        }
    }
}
