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
        VStack(alignment: .center, spacing: 50) {
            HStack(alignment: .center) {
                Image("AppIconImage")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 86)
                
                VStack(alignment: .leading) {
                    Text("ScratchPad")
                        .font(.system(size: 42))
                    
                    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String {
                        Text("version \(appVersion)")
                    }
                }
            }
            
            Button(action: {
                commandsModel.welcomeSheetOpen = false
            }) {
                Text("Continue")
                    .frame(width: 150)
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
