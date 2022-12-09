//
//  SettingsModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

final class SettingsModel: ObservableObject {
    @Published var windowTransparency = UserDefaults.standard.value(forKey: "windowTransparency") as? Double ?? 100 {
        didSet {
            UserDefaults.standard.set(windowTransparency, forKey: "windowTransparency")
            
            // TODO: change window transparency
        }
    }

    @Published var floatAboveOtherWindows = UserDefaults.standard.bool(forKey: "floatAboveOtherWindows") {
        didSet {
            UserDefaults.standard.set(floatAboveOtherWindows, forKey: "floatAboveOtherWindows")
            
            // TODO: change window float
        }
    }
    
    @Published var storageLocation: URL? {
        didSet {
            do {
                // TODO: what about the default URL?
                let bookmarkData = try storageLocation!.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                
                UserDefaults.standard.set(bookmarkData, forKey: "storageLocationBookmarkData")
                setFormattedStorageLocation()
                
                // TODO: asynchronously move files
            } catch {
                print(error)
            }
        }
    }
    
    @Published var formattedStorageLocation: String?
    
    private var defaultStorageLocation: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentURL.appendingPathComponent("ScratchPad")
    }
    
    init() {
        if let bookmarkData = UserDefaults.standard.object(forKey: "storageLocationBookmarkData") as? Data {
            var isStale = false
            storageLocation = try? URL(resolvingBookmarkData: bookmarkData, options: [.withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &isStale)
        }
        else {
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
