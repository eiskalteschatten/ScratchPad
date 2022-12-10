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
    
    private var previousStorageLocation: URL?
    
    @Published var storageLocation: URL? {
        willSet {
            previousStorageLocation = storageLocation
        }
        didSet {
            do {
                if let unwrappedLocation = storageLocation {
                    let bookmarkData = try unwrappedLocation.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    
                    UserDefaults.standard.set(bookmarkData, forKey: "storageLocationBookmarkData")
                    setFormattedStorageLocation()
                    
                    if let unwrappedPreviousLocation = previousStorageLocation,
                       let unwrappedStorageLocation = storageLocation,
                       storageLocation != previousStorageLocation {
                        let fileManager = FileManager.default
                        let allFiles = try fileManager.contentsOfDirectory(atPath: unwrappedPreviousLocation.path)

                        let noteFileRegex = try! NSRegularExpression(pattern: "note(\\d*)\\.rtfd$")
                        let notes = allFiles.filter {
                            let matches = noteFileRegex.matches(in: $0, options: [], range: .init(location: 0, length: $0.count))
                            return matches.count > 0
                        }
                        
                        for note in notes {
                            let oldURL = unwrappedPreviousLocation.appendingPathComponent(note)
                            let newURL = unwrappedStorageLocation.appendingPathComponent(note)
                            
                            try fileManager.moveItem(atPath: oldURL.path, toPath: newURL.path)
                        }
                    }
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
