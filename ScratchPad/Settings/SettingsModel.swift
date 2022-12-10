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
    
    @Published var storageLocation: URL? {
        didSet {
            do {
                if let unwrappedLocation = storageLocation {
                    let bookmarkData = try unwrappedLocation.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    
                    UserDefaults.standard.set(bookmarkData, forKey: "storageLocationBookmarkData")
                    setFormattedStorageLocation()
                    
                    // TODO: move files
                }
            } catch {
                print(error)
                ErrorHandling.showErrorToUser(error.localizedDescription)
            }
        }
    }
    
    @Published var formattedStorageLocation: String?
    
    private var defaultStorageLocation: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentURL.appendingPathComponent("ScratchPad")
    }
    
    private var usesDefaultStorageLocation: Bool {
        return storageLocation == defaultStorageLocation
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
        do {
            if !FileManager.default.fileExists(atPath: defaultStorageLocation.path) {
                try FileManager.default.createDirectory(atPath: defaultStorageLocation.path, withIntermediateDirectories: true, attributes: nil)
            }
            
            storageLocation = defaultStorageLocation
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
    }
    
    private func setFormattedStorageLocation() {
        if usesDefaultStorageLocation {
            formattedStorageLocation = "Your Documents folder"
        }
        else {
            guard let locationString = storageLocation?.absoluteString else { return }
            formattedStorageLocation = locationString.replacingOccurrences(of: "file://", with: "")
        }
    }
}
