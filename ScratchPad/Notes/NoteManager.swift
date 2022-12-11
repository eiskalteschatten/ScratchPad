//
//  NoteManager.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import SwiftUI

final class NoteManager {
    static let NOTE_NAME_PREFIX = "Note"
    
    static func moveNotes(from: URL, to: URL) {
        do {
            let fileManager = FileManager.default
            let allFiles = try fileManager.contentsOfDirectory(atPath: from.path)
            
            let noteFileRegex = try! NSRegularExpression(pattern: "\(NOTE_NAME_PREFIX) (\\d*)\\.rtfd$")
            let notes = allFiles.filter {
                let matches = noteFileRegex.matches(in: $0, options: [], range: .init(location: 0, length: $0.count))
                return matches.count > 0
            }
            
            for note in notes {
                let oldURL = from.appendingPathComponent(note)
                let newURL = to.appendingPathComponent(note)
                
                try fileManager.moveItem(atPath: oldURL.path, toPath: newURL.path)
            }
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
    }
}
