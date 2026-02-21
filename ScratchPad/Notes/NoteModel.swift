//
//  NoteModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI
import Combine

final class NoteModel: ObservableObject {
    private var storageLocationModel: StorageLocationModel
    private var switchingPages = false

    @Published var pageNumber = UserDefaults.standard.value(forKey: "pageNumber") as? Int ?? 1 {
        didSet {
            UserDefaults.standard.set(pageNumber, forKey: "pageNumber")
            switchingPages = true
            noteContents = AttributedString()
            openNote()
            switchingPages = false
        }
    }
    
    @Published var noteContents = AttributedString() {
        didSet {
            if !switchingPages {
                saveNote()
            }
        }
    }
    
    private var noteName: String {
        return "\(NoteManager.NOTE_NAME_PREFIX) \(pageNumber).\(NoteManager.NOTE_NAME_EXTENSION)"
    }
    
    init(storageLocationModel: StorageLocationModel) {
        self.storageLocationModel = storageLocationModel
        openNote()
    }
    
    func openNote() {
        let fullURL = storageLocationModel.storageLocation!.appendingPathComponent(noteName)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtfd]
        
        do {
            if let _ = try? fullURL.checkResourceIsReachable() {
                let nsAttributedString = try NSAttributedString(url: fullURL, options: options, documentAttributes: nil)
                noteContents = (try? AttributedString(nsAttributedString, including: \.appKit)) ?? AttributedString(nsAttributedString)
            }
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
    }
    
    private func saveNote() {
        let fullURL = storageLocationModel.storageLocation!.appendingPathComponent(noteName)

        do {
            let nsContents = (try? NSAttributedString(noteContents, including: \.appKit)) ?? NSAttributedString(noteContents)
            if nsContents.length == 0 && FileManager.default.fileExists(atPath: fullURL.path) {
                try FileManager.default.removeItem(atPath: fullURL.path)
            }
            else {
                let rtdf = nsContents.rtfdFileWrapper(from: .init(location: 0, length: nsContents.length))
                try rtdf?.write(to: fullURL, options: .atomic, originalContentsURL: nil)
            }
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
    }
    
    func deleteNote() {
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to delete this page?"
        alert.informativeText = "All contents will be deleted. This cannot be undone."
        alert.addButton(withTitle: "No")
        alert.addButton(withTitle: "Yes")
        alert.alertStyle = .warning
        
        alert.buttons.last?.hasDestructiveAction = true
        
        let response = alert.runModal()
        
        if response == .alertSecondButtonReturn {
            noteContents = AttributedString()
        }
    }
    
    func exportNote() {
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.nameFieldStringValue = noteName
        let response = savePanel.runModal()
        
        if response == .OK {
            guard let saveURL = savePanel.url else { return }
            let nsContents = (try? NSAttributedString(noteContents, including: \.appKit)) ?? NSAttributedString(noteContents)
            let rtdf = nsContents.rtfdFileWrapper(from: .init(location: 0, length: nsContents.length))
            
            do {
                try rtdf?.write(to: saveURL, options: .atomic, originalContentsURL: nil)
            } catch {
                print(error)
                ErrorHandling.showErrorToUser(error.localizedDescription)
            }
        }
    }
    
    func appendNewNote() {
        do {
            guard let currentLastPageNumber = try NoteManager.getLastPageNumber() else {
                ErrorHandling.showNewNoteCouldNotBeCreatedError()
                return
            }
            
            pageNumber = currentLastPageNumber + 1
        } catch {
            ErrorHandling.showNewNoteCouldNotBeCreatedError()
        }
    }
    
    func goToFirstPage() {
        pageNumber = 1
    }
    
    func goToLastPage() {
        do {
            guard let currentLastPageNumber = try NoteManager.getLastPageNumber() else {
                ErrorHandling.showCouldNotFindLastPage()
                return
            }
            
            pageNumber = currentLastPageNumber
        } catch {
            ErrorHandling.showCouldNotFindLastPage()
        }
    }
}
