//
//  Toolbar.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct Toolbar: View {
    @EnvironmentObject var noteModel: NoteModel
    
    @FocusState private var pageNumberTextfieldIsFocused: Bool
    
    var body: some View {
        Button(action: {
            noteModel.appendNewNote()
        }) {
            Label("New Page", systemImage: "plus")
        }
        
        Button(action: {
            if noteModel.pageNumber > 1 {
                noteModel.pageNumber -= 1
            }
            
            unfocusPageNumberTextfield()
        }) {
            Label("Back", systemImage: "chevron.left")
        }
        .disabled(noteModel.pageNumber <= 1)
        
        Button(action: {
            noteModel.pageNumber += 1
            unfocusPageNumberTextfield()
        }) {
            Label("Forward", systemImage: "chevron.right")
        }
        
        TextField("", value: Binding<Int>(
            get: { noteModel.pageNumber },
            set: { noteModel.pageNumber = abs($0) }
        ), formatter: NumberFormatter())
        .multilineTextAlignment(.center)
        .focused($pageNumberTextfieldIsFocused)
        .frame(width: 50)
    }
    
    private func unfocusPageNumberTextfield() {
        pageNumberTextfieldIsFocused = false
    }
}

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar()
    }
}
