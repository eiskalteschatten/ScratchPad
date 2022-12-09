//
//  SettingsModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

final class SettingsModel: ObservableObject {
    @AppStorage("storageLocation") var storageLocation: URL? {
        didSet {
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
