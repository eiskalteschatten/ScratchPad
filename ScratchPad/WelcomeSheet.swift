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
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .center) {
                    Image("AppIconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 65)
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading) {
                        Text("ScratchPad")
                            .font(.system(size: 42))
                        
                        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            Text("version \(appVersion)")
                        }
                    }
                }
            
                Text("Welcome to ScratchPad 2!")
                    .font(.system(size: 16))
                    .bold()
                
                Text("Version 2 of ScratchPad has finally arrived. The first version of ScratchPad was released in 2007 for Mac OS X Tiger (10.4) and was updated through Mac OS X El Capitan (10.11).")
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                Text("This version is a complete rewrite of ScratchPad from the ground up using modern macOS technologies such as SwiftUI. It runs natively on both Intel and Apple Silicon Macs and supports modern macOS features such as Dark Mode.")
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                Text("Importing Your Notes from ScratchPad 1")
                    .font(.headline)
                    .padding(.top, 15)
                
                Text("Since macOS has updated its security policies for the way applications are allowed to run, it is not possible to automatically import your notes from ScratchPad 1.")
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                Text("However, you can manually import them by clicking on \"File\", then \"Import from Version 1...\" and following the instructions from there. Alternatively, you can click the button below.")
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                Button("Import from Version 1...") {
                    close()
                    commandsModel.importSheetOpen = true
                }
                .buttonStyle(.link)
            }
            
            Button(action: close) {
                Text("Continue")
                    .frame(width: 150)
            }
        }
        .frame(width: 500)
        .padding()
    }
    
    private func close() {
        commandsModel.welcomeSheetOpen = false
        UserDefaults.standard.set(false, forKey: "openWelcomeSheetOnLaunch")
    }
}

struct WelcomeSheet_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSheet()
    }
}
