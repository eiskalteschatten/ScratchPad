//
//  NoteManager.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import SwiftUI

final class NoteManager {
    static let NOTE_NAME_PREFIX = "Note"
    
    static func getNoteFileList(_ from: URL) throws -> [String] {
        let allFiles = try FileManager.default.contentsOfDirectory(atPath: from.path)
        
        let noteFileRegex = try! NSRegularExpression(pattern: "\(NOTE_NAME_PREFIX) (\\d*)\\.rtfd$")
        let notes = allFiles.filter {
            let matches = noteFileRegex.matches(in: $0, options: [], range: .init(location: 0, length: $0.count))
            return matches.count > 0
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
            let storageLocation = try URL(resolvingBookmarkData: bookmarkData, options: [.withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard storageLocation.startAccessingSecurityScopedResource() else {
                ErrorHandling.showStroageLocationNotAccessible()
                return nil
            }
            
            let notes = try getNoteFileList(storageLocation)
            
            let pageNumbers = notes.compactMap {
                let noteURL = storageLocation.appendingPathComponent($0)
                let fileName = noteURL.deletingPathExtension().lastPathComponent
                let pageNumber = fileName.replacingOccurrences(of: "\(NOTE_NAME_PREFIX) ", with: "")
                return Int(pageNumber)
            }.sorted()
            
            storageLocation.stopAccessingSecurityScopedResource()
            
            return pageNumbers.last ?? 1
        }
        
        return nil
    }
    
    static func importNotes(from: URL) {
        do {
            guard let bookmarkData = UserDefaults.standard.object(forKey: "storageLocationBookmarkData") as? Data else {
                ErrorHandling.showStroageLocationNotFoundError()
                return
            }
            
            var isStale = false
            let storageLocation = try URL(resolvingBookmarkData: bookmarkData, options: [.withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            guard storageLocation.startAccessingSecurityScopedResource() else {
                ErrorHandling.showStroageLocationNotAccessible()
                return
            }
            
            let notes = try getNoteFileList(from)
            
            guard let lastPageNumber = try NoteManager.getLastPageNumber() else {
                throw ErrorWithMessage("No last page number could be found!")
            }
            
            // TODO: move notes to the storage location after the last page
//            for note in notes {
//                let oldURL = from.appendingPathComponent(note)
//                let newURL = to.appendingPathComponent(note)
//
//                try FileManager.default.moveItem(atPath: oldURL.path, toPath: newURL.path)
//            }
            
            storageLocation.stopAccessingSecurityScopedResource()
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
    }
}
