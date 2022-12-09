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
    
    @SceneStorage("pageNumber") var pageNumber: Int?
    
    init() {
        noteContents = NSAttributedString(string: "")
    }
}


