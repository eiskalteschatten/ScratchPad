//
//  SettingsModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

final class SettingsModel: ObservableObject {
    @Published var windowTransparency = UserDefaults.standard.value(forKey: "windowTransparency") as? Double ?? 100{
        didSet {
            UserDefaults.standard.set(windowTransparency, forKey: "windowTransparency")
            
            // TODO: change window transparency
        }
    }

    @Published var storageLocation = UserDefaults.standard.url(forKey: "storageLocation") {
        didSet {
            UserDefaults.standard.set(storageLocation, forKey: "storageLocation")
            
            // TODO: asynchronously move files
        }
    }
    
    init() {
        if storageLocation == nil {
            resetStorageLocation()
        }
    }
    
    func resetStorageLocation() {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        storageLocation = documentURL.appendingPathComponent("ScratchPad")
    }
}
