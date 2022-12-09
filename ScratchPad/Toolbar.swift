//
//  Toolbar.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct Toolbar: View {
    @ObservedObject var noteModel: NoteModel
    
    var body: some View {
        Button(action: { print("back") } ) {
            Label("Back", systemImage: "chevron.left")
        }
        Button(action: { print("forward") } ) {
            Label("Forward", systemImage: "chevron.right")
        }
        TextField("", text: $noteModel.pageNumberString)
            .frame(width: 30)
    }
}

struct Toolbar_Previews: PreviewProvider {
    @ObservedObject private static var noteModel = NoteModel()
    
    static var previews: some View {
        Toolbar(noteModel: noteModel)
    }
}
