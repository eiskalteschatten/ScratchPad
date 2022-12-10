//
//  NoteModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI
import Combine

final class NoteModel: ObservableObject {
    private var switchingPages = false

    @Published var pageNumber = UserDefaults.standard.value(forKey: "pageNumber") as? Int ?? 1 {
        didSet {
            UserDefaults.standard.set(pageNumber, forKey: "pageNumber")
            switchingPages = true
            noteContents = NSAttributedString(string: "")
            openNote()
            switchingPages = false
        }
    }
    
    @Published var noteContents = NSAttributedString(string: "") {
        didSet {
            if !switchingPages {
                saveNote()
            }
        }
    }
    
    private var noteName: String {
        return "\(NoteManager.NOTE_NAME_PREFIX)\(pageNumber).rtfd"
    }
    
    init() {
        openNote()
    }
    
    private func openNote() {
        // This is necessary, but macOS seems to recover the stale bookmark automatically, so don't handle it for now
        var isStale = false
        
        guard let bookmarkData = UserDefaults.standard.object(forKey: "storageLocationBookmarkData") as? Data,
              let storageLocation = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        else {
            ErrorHandling.showErrorToUser("No storage location for your notes could be found!", informativeText: "Please try re-selecting your storage location in the settings.")
            return
        }
        
        let fullURL = storageLocation.appendingPathComponent(noteName)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtfd]
        
        do {
            guard storageLocation.startAccessingSecurityScopedResource() else {
                ErrorHandling.showErrorToUser("ScratchPad is not allowed to access the storage location for your notes!", informativeText: "Please try re-selecting your storage location in the settings.")
                return
            }
            
            if let _ = try? fullURL.checkResourceIsReachable() {
                let attributedString = try NSAttributedString(url: fullURL, options: options, documentAttributes: nil)
                noteContents = attributedString
            }
            
            fullURL.stopAccessingSecurityScopedResource()
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
    }
    
    private func saveNote() {
        // This is necessary, but macOS seems to recover the stale bookmark automatically, so don't handle it for now
        var isStale = false
                
        guard let bookmarkData = UserDefaults.standard.object(forKey: "storageLocationBookmarkData") as? Data,
              let storageLocation = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        else {
            ErrorHandling.showErrorToUser("No storage location for your notes could be found!", informativeText: "Please try re-selecting your storage location in the settings.")
            return
        }
        
        let fullURL = storageLocation.appendingPathComponent(noteName)

        do {
            guard storageLocation.startAccessingSecurityScopedResource() else {
                ErrorHandling.showErrorToUser("ScratchPad is not allowed to access the storage location for your notes!", informativeText: "Please try re-selecting your storage location in the settings.")
                return
            }
            
            let rtdf = noteContents.rtfdFileWrapper(from: .init(location: 0, length: noteContents.length))
            try rtdf?.write(to: fullURL, options: .atomic, originalContentsURL: nil)
            fullURL.stopAccessingSecurityScopedResource()
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
    }
}
