//
//  ContentView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var noteModel: NoteModel
    
    var body: some View {
        RichTextEditor(noteModel: noteModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                Toolbar(noteModel: noteModel)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    @ObservedObject private static var noteModel = NoteModel()
    
    static var previews: some View {
        ContentView(noteModel: noteModel)
    }
}
