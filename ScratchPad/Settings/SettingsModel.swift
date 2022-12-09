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
            setFormattedStorageLocation()
            
            // TODO: asynchronously move files
        }
    }
    
    @Published var formattedStorageLocation: String?
    
    private var defaultStorageLocation: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentURL.appendingPathComponent("ScratchPad")
    }
    
    init() {
        if storageLocation == nil {
            resetStorageLocation()
        }
        
        setFormattedStorageLocation()
    }
    
    func resetStorageLocation() {
        storageLocation = defaultStorageLocation
    }
    
    private func setFormattedStorageLocation() {
        if storageLocation == defaultStorageLocation {
            formattedStorageLocation = "Your Documents folder"
        }
        else {
            guard let locationString = storageLocation?.absoluteString else { return }
            formattedStorageLocation = locationString.replacingOccurrences(of: "file://", with: "")
        }
    }
}
