//
//  ContentView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct ContentView: View {
    @State private var noteContent = NSAttributedString(string: "")
    
    var body: some View {
        RichTextEditor(text: $noteContent)
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
