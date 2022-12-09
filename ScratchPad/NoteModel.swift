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
    
    @AppStorage("pageNumber") var pageNumber: Int?
    
    @Published var pageNumberString: String = "" {
        didSet {
            guard let pageNumberInt = Int(pageNumberString) else {
                return
            }
            pageNumber = pageNumberInt
        }
    }
    
    init() {
        noteContents = NSAttributedString(string: "")
        
        if let unwrappedPageNumber = pageNumber {
            pageNumberString = String(unwrappedPageNumber)
        }
    }
    
    func initPageNumber() {
        if (pageNumber == nil) {
            pageNumber = 1
        }
    }
}


