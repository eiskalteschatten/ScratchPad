//
//  NoteModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI
import Combine

final class NoteModel: ObservableObject {
    private let NOTE_NAME_PREFIX = "note"
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
    
    @Published var noteContents: NSAttributedString {
        didSet {
            if !switchingPages {
                saveNote()
            }
        }
    }
    
    private var noteName: String {
        return "\(NOTE_NAME_PREFIX)\(pageNumber).rtfd"
    }
    
    init() {
        noteContents = NSAttributedString(string: "")
        openNote()
    }
    
    private func openNote() {
        var isStale = false {
            didSet {
                // TODO: handle stale bookmarks
            }
        }
        
        guard let bookmarkData = UserDefaults.standard.object(forKey: "storageLocationBookmarkData") as? Data,
              let storageLocation = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        else {
            // TODO: do something. This is a bad error!
            print("error1")
            return
        }
        
        let fullURL = storageLocation.appendingPathComponent(noteName)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtfd]
        
        do {
            guard storageLocation.startAccessingSecurityScopedResource() else {
                // TODO: do something. This is a bad error!
                print("accessing not allowed")
                return
            }
            
            if let _ = try? fullURL.checkResourceIsReachable() {
                let attributedString = try NSAttributedString(url: fullURL, options: options, documentAttributes: nil)
                noteContents = attributedString
            }
            
            fullURL.stopAccessingSecurityScopedResource()
        } catch {
            // TODO: do something here. This is also a bad error!
            print(error)
        }
    }
    
    private func saveNote() {
        var isStale = false {
            didSet {
                // TODO: handle stale bookmarks
            }
        }
        
        guard let bookmarkData = UserDefaults.standard.object(forKey: "storageLocationBookmarkData") as? Data,
            let storageLocation = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        else {
            // TODO: do something. This is a bad error!
            print("error1")
            return
        }
        
        let fullURL = storageLocation.appendingPathComponent(noteName)

        do {
            guard storageLocation.startAccessingSecurityScopedResource() else {
                // TODO: do something. This is a bad error!
                print("accessing not allowed")
                return
            }
            
            let rtdf = noteContents.rtfdFileWrapper(from: .init(location: 0, length: noteContents.length))
            try rtdf?.write(to: fullURL, options: .atomic, originalContentsURL: nil)
            fullURL.stopAccessingSecurityScopedResource()
        } catch {
            // TODO: do something here. This is also a bad error!
            print(error.localizedDescription)
        }
    }
}
