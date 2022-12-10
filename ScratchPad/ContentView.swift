//
//  ContentView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var noteModel: NoteModel
    @EnvironmentObject var commandsModel: CommandsModel
    
    var body: some View {
        RichTextEditor()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                Toolbar()
            }
            .sheet(isPresented: $commandsModel.importSheetOpen) {
                ImportView()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
