//
//  ContentView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var noteModel = NoteModel()
    
    var body: some View {
        RichTextEditor(noteModel: noteModel)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                Toolbar()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
