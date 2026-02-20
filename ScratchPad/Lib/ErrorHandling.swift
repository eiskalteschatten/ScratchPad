//
//  ErrorHandling.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import SwiftUI

final class ErrorHandling {
    static func showErrorToUser(_ errorString: String, informativeText: String? = nil) {
        let alert = NSAlert()
        alert.messageText = errorString
        
        if let unwrappedInformativeText = informativeText {
            alert.informativeText = unwrappedInformativeText
        }
        
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .critical
        alert.runModal()
    }
    
    static func showStorageLocationNotAccessible() {
        showErrorToUser("ScratchPad is not allowed to access the storage location for your notes!", informativeText: "Please try re-selecting your storage location in the settings.")
    }
    
    static func showStorageLocationNotFoundError() {
        showErrorToUser("The storage location for your notes could not be determined", informativeText: "Please re-select your storage location in the Settings and try again.")
    }
    
    static func showNewNoteCouldNotBeCreatedError() {
        showErrorToUser("A new note could not be added!", informativeText: "Please manually navigate past the last page to create a new note.")
    }
    
    static func showCouldNotFindLastPage() {
        showErrorToUser("ScratchPad could not find the last page!", informativeText: "Please manually navigate to the last page.")
    }
}

struct ErrorWithMessage: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}
