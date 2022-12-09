//
//  Toolbar.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct Toolbar: View {
    @State private var pageNumber: String = ""
    
    var body: some View {
        Button(action: { print("back") } ) {
            Label("Back", systemImage: "chevron.left")
        }
        Button(action: { print("forward") } ) {
            Label("Forward", systemImage: "chevron.right")
        }
        TextField("", text: $pageNumber)
            .frame(width: 30)
    }
}

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        Toolbar()
    }
}
