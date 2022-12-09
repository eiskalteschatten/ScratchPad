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

    @Published var pageNumber = UserDefaults.standard.value(forKey: "pageNumber") as? Int ?? 1 {
        didSet {
            UserDefaults.standard.set(pageNumber, forKey: "pageNumber")
            openNote()
        }
    }
    
    private var noteContentsBag = Set<AnyCancellable>()
    @Published var noteContents: NSAttributedString
    
    private var noteName: String {
        return "\(NOTE_NAME_PREFIX)\(pageNumber).rtfd"
    }
    
    init() {
        noteContents = NSAttributedString(string: "")
        
        $noteContents
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { self.saveNote($0) }
            .store(in: &noteContentsBag)
        
        openNote()
    }
    
    private func openNote() {
        var isStale = false {
            didSet {
                // TODO: handle stale bookmarks
                print("isStale: \(isStale)")
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
            
            let attributedString = try NSAttributedString(url: fullURL, options: options, documentAttributes: nil)
            noteContents = attributedString
            fullURL.stopAccessingSecurityScopedResource()
        } catch {
            // TODO: do something here. This is also a bad error!
            print(error)
        }
    }
    
    private func saveNote(_ contents: NSAttributedString) {
        var isStale = false
        
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
            
            let rtdf = contents.rtfdFileWrapper(from: .init(location: 0, length: contents.length))
            try rtdf?.write(to: fullURL, options: .atomic, originalContentsURL: nil)
            fullURL.stopAccessingSecurityScopedResource()
        } catch {
            // TODO: do something here. This is also a bad error!
            print(error.localizedDescription)
        }
    }
}
