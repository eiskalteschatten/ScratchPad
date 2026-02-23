//
//  StorageLocationModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 21.02.26.
//

import SwiftUI

final class StorageLocationModel: ObservableObject {
    #if DEBUG
    let scratchPadFolderName = "ScratchPad-debug"
    #else
    let scratchPadFolderName = "ScratchPad"
    #endif
    
    private var previousStorageLocation: URL?
    private var securityScopedURL: URL?
    
    @Published var formattedStorageLocation: String?
    
    @Published var storageLocation: URL? {
        willSet {
            previousStorageLocation = storageLocation
        }
        didSet {
            do {
                if let unwrappedLocation = storageLocation {
                    if !FileManager.default.fileExists(atPath: unwrappedLocation.path) {
                        try FileManager.default.createDirectory(atPath: unwrappedLocation.path, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    if usesDefaultStorageLocation {
                        // The default location is inside the app's sandbox container and doesn't
                        // support security-scoped bookmarks. Clear any saved bookmark so that
                        // init() falls through to resetStorageLocation() on the next launch.
                        UserDefaults.standard.removeObject(forKey: UserDefaultsConfig.storageLocationBookmarkData)
                    } else {
                        let bookmarkData = try unwrappedLocation.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                        UserDefaults.standard.set(bookmarkData, forKey: UserDefaultsConfig.storageLocationBookmarkData)
                    }
                    
                    if let unwrappedPreviousLocation = previousStorageLocation,
                       let unwrappedStorageLocation = storageLocation,
                       storageLocation != previousStorageLocation {
                        NoteManager.moveNotes(from: unwrappedPreviousLocation, to: unwrappedStorageLocation)
                    }
                    
                    // Stop accessing the previous security-scoped resource only after the move
                    // is complete, so that moveNotes can still read from the old location.
                    if let scoped = securityScopedURL, scoped != storageLocation {
                        scoped.stopAccessingSecurityScopedResource()
                        securityScopedURL = nil
                    }
                }
            } catch {
                print(error)
                ErrorHandling.showErrorToUser(error.localizedDescription)
            }
        }
    }
    
    var usesDefaultStorageLocation: Bool {
        return storageLocation?.path == defaultStorageLocation.path
    }
    
    private var defaultStorageLocation: URL {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        /// Note: This is necessary for the comparison in usesDefaultStorageLocation to work
        return documentURL.appendingPathComponent(scratchPadFolderName)
    }
    
    init() {
        if let bookmarkData = UserDefaults.standard.object(forKey: UserDefaultsConfig.storageLocationBookmarkData) as? Data {
            var isStale = false
            if let resolved = try? URL(resolvingBookmarkData: bookmarkData, options: [.withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &isStale) {
                guard resolved.startAccessingSecurityScopedResource() else {
                    UserDefaults.standard.removeObject(forKey: UserDefaultsConfig.storageLocationBookmarkData)
                    handleStorageLocationNotFound()
                    return
                }
                securityScopedURL = resolved
                if isStale {
                    // Renew the stale bookmark now that we have access
                    if let renewed = try? resolved.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) {
                        UserDefaults.standard.set(renewed, forKey: UserDefaultsConfig.storageLocationBookmarkData)
                    }
                }
                storageLocation = resolved
            }
            else {
                UserDefaults.standard.removeObject(forKey: UserDefaultsConfig.storageLocationBookmarkData)
                handleStorageLocationNotFound()
            }
        }
        else {
            resetStorageLocation()
        }
        
        setFormattedStorageLocation()
    }
    
    private func handleStorageLocationNotFound() {
        let alert = NSAlert()
        alert.messageText = String(localized: "Storage Location Not Found")
        alert.informativeText = String(localized: "The folder where your notes are stored could not be found. Would you like to choose a new location or reset to the default?")
        alert.addButton(withTitle: String(localized: "Choose Location..."))
        alert.addButton(withTitle: String(localized: "Use Default Location"))
        
        let response = alert.runModal()
        
        if response == .alertFirstButtonReturn {
            let openPanel = NSOpenPanel()
            openPanel.allowsMultipleSelection = false
            openPanel.canChooseDirectories = true
            openPanel.canChooseFiles = false
            openPanel.canCreateDirectories = true
            
            if openPanel.runModal() == .OK, var newLocation = openPanel.url {
                if newLocation.lastPathComponent != scratchPadFolderName {
                    newLocation = newLocation.appendingPathComponent(scratchPadFolderName)
                }
                storageLocation = newLocation
            }
            else {
                resetStorageLocation()
            }
        }
        else {
            resetStorageLocation()
        }
    }
    
    func resetStorageLocation() {
        storageLocation = defaultStorageLocation
        setFormattedStorageLocation()
    }
    
    func selectStorageLocation() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canCreateDirectories = true
        let response = openPanel.runModal()
        
        if response == .OK {
            guard var newLocation = openPanel.url else {
                ErrorHandling.showErrorToUser(String(localized: "The folder you selected is invalid."), informativeText: String(localized: "Please select a different folder."))
                return
            }
            
            if newLocation.lastPathComponent != scratchPadFolderName {
                newLocation = newLocation.appendingPathComponent(scratchPadFolderName)
            }
            
            storageLocation = newLocation
            setFormattedStorageLocation()
        }
    }
    
    private func setFormattedStorageLocation() {
        if usesDefaultStorageLocation {
            formattedStorageLocation = String(localized: "Default Location", comment: "")
        }
        else {
            guard let locationString = storageLocation?.absoluteString else { return }
            formattedStorageLocation = locationString.replacingOccurrences(of: "file://", with: "")
        }
    }
}
