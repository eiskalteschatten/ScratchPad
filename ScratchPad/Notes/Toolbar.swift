//
//  Toolbar.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct Toolbar: View {
    @EnvironmentObject var noteModel: NoteModel
    
    var body: some View {
        Button(action: {
            noteModel.initPageNumber();
            noteModel.pageNumber! -= 1
        } ) {
            Label("Back", systemImage: "chevron.left")
        }
        .disabled(noteModel.pageNumber == nil || noteModel.pageNumber! <= 1)
        
        Button(action: {
            noteModel.initPageNumber();
            noteModel.pageNumber! += 1
        } ) {
            Label("Forward", systemImage: "chevron.right")
        }
        
        TextField("", text: $noteModel.pageNumberString)
            .frame(width: 30)
    }
}

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar()
    }
}
