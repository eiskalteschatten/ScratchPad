//
//  NoteModel.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

final class NoteModel: ObservableObject {
    @Published var noteContents: NSAttributedString {
        didSet {
            // TODO: save the note contents
            
            print("note contents changed")
        }
    }
    
    @Published var pageNumber = UserDefaults.standard.value(forKey: "pageNumber") as? Int ?? 1 {
        didSet {
            UserDefaults.standard.set(pageNumber, forKey: "pageNumber")
            
            // TODO: load note contents and set noteContents
        }
    }
    
    init() {
        noteContents = NSAttributedString(string: "")
    }
}
