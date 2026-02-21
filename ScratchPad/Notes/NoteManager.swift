//
//  NoteManager.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import SwiftUI

final class NoteManager {
    static let NOTE_NAME_PREFIX = "Note"
    static let NOTE_NAME_EXTENSION = "rtfd"
    
    static func getPageNumberFromNoteName(_ name: String) -> Int? {
        let cleanedName = name.replacingOccurrences(of: ".\(NOTE_NAME_EXTENSION)", with: "").replacingOccurrences(of: "\(NOTE_NAME_PREFIX) ", with: "")
        return Int(cleanedName)
    }
    
    static func getNoteFileList(_ from: URL, sorted: Bool = false) throws -> [String] {
        let allFiles = try FileManager.default.contentsOfDirectory(atPath: from.path)
        let noteFileRegex = try! NSRegularExpression(pattern: "\(NOTE_NAME_PREFIX) (\\d*)\\.\(NOTE_NAME_EXTENSION)$")
        
        var notes = allFiles.filter {
            let matches = noteFileRegex.matches(in: $0, options: [], range: .init(location: 0, length: $0.count))
            return matches.count > 0
        }
        
        if sorted {
            notes.sort() {
                guard let pageNumber1 = getPageNumberFromNoteName($0) else { return false }
                guard let pageNumber2 = getPageNumberFromNoteName($1) else { return false }
                return pageNumber1 < pageNumber2
            }
        }
        
        return notes
    }
    
    static func moveNotes(from: URL, to: URL) {
        do {
            let notes = try getNoteFileList(from)
            
            for note in notes {
                let oldURL = from.appendingPathComponent(note)
                let newURL = to.appendingPathComponent(note)
                
                try FileManager.default.moveItem(atPath: oldURL.path, toPath: newURL.path)
            }
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
    }
    
    static func getLastPageNumber() throws -> Int? {
        if let bookmarkData = UserDefaults.standard.object(forKey: "storageLocationBookmarkData") as? Data {
            var isStale = false
            let storageLocation = try URL(resolvingBookmarkData: bookmarkData, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            let notes = try getNoteFileList(storageLocation)
            
            let pageNumbers = notes.compactMap {
                let noteURL = storageLocation.appendingPathComponent($0)
                let fileName = noteURL.deletingPathExtension().lastPathComponent
                let pageNumber = fileName.replacingOccurrences(of: "\(NOTE_NAME_PREFIX) ", with: "")
                return Int(pageNumber)
            }.sorted()
            
            return pageNumbers.last ?? 1
        }
        
        return nil
    }
    
    static func importNotes(from: URL) {
        do {
            guard let bookmarkData = UserDefaults.standard.object(forKey: "storageLocationBookmarkData") as? Data else {
                ErrorHandling.showStorageLocationNotFoundError()
                return
            }
            
            var isStale = false
            let storageLocation = try URL(resolvingBookmarkData: bookmarkData, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard let currentLastPageNumber = try NoteManager.getLastPageNumber() else {
                throw ErrorWithMessage(String(localized: "No last page number could be found!"))
            }
            
            let notesToImport = try getNoteFileList(from, sorted: true)
            var firstPageExists = true
            
            if currentLastPageNumber == 1 {
                let firstPageURL = storageLocation.appendingPathComponent("\(NoteManager.NOTE_NAME_PREFIX) 1.\(NoteManager.NOTE_NAME_EXTENSION)")
                firstPageExists = FileManager.default.fileExists(atPath: firstPageURL.path)
            }
            
            for note in notesToImport {
                if let pageNumber = getPageNumberFromNoteName(note) {
                    let oldURL = from.appendingPathComponent(note)
                    
                    // Append the imported notes after the last note if page 1 exists
                    var newNoteName = note
                    
                    if firstPageExists {
                        let newPageNumber = pageNumber + currentLastPageNumber
                        newNoteName = "\(NoteManager.NOTE_NAME_PREFIX) \(newPageNumber).\(NoteManager.NOTE_NAME_EXTENSION)"
                    }
                    
                    let newURL = storageLocation.appendingPathComponent(newNoteName)
                    
                    try FileManager.default.moveItem(atPath: oldURL.path, toPath: newURL.path)
                }
            }
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
    }
}
