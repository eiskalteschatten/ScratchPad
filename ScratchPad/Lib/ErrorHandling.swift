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
}
