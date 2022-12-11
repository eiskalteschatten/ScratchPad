//
//  WelcomeSheet.swift
//  ScratchPad
//
//  Created by Alex Seifert on 11.12.22.
//

import SwiftUI

struct WelcomeSheet: View {
    @EnvironmentObject var commandsModel: CommandsModel
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Button("Continue") {
                commandsModel.welcomeSheetOpen = false
            }
        }
        .padding()
    }
}

struct WelcomeSheet_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSheet()
    }
}
