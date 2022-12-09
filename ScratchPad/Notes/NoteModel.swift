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
        guard let storageLocation = UserDefaults.standard.url(forKey: "storageLocation") else {
            // TODO: do something. This is a bad error!
            print("error1")
            return
        }
        
        let fullURL = storageLocation.appendingPathComponent(noteName)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtfd]
        
        do {
            if fullURL.startAccessingSecurityScopedResource() {
                let attributedString = try NSAttributedString(url: fullURL, options: options, documentAttributes: nil)
                noteContents = attributedString
                fullURL.stopAccessingSecurityScopedResource()
            }
        } catch {
            // TODO: do something here. This is also a bad error!
            print(error)
        }
    }
    
    private func saveNote(_ contents: NSAttributedString) {
        guard let storageLocation = UserDefaults.standard.url(forKey: "storageLocation") else {
            // TODO: do something. This is a bad error!
            print("error1")
            return
        }
        
        let fullURL = storageLocation.appendingPathComponent(noteName)

        do {
            if fullURL.startAccessingSecurityScopedResource() {
                try contents.rtfd().write(to: fullURL)
                fullURL.stopAccessingSecurityScopedResource()
            }
        } catch {
            // TODO: do something here. This is also a bad error!
            print(error.localizedDescription)
        }
    }
}
