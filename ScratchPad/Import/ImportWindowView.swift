//
//  ImportWindowView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import SwiftUI

struct ImportWindowView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("This importer will import your notes and settings from ScratchPad version 1.x.")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("Press the Import button to continue.")
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Button("Import") {
                // TODO:
                // 1. Check if there is a ScratchPad folder in Application Support
                // 2. If so, import the settings
                // 3. Make sure the storage location is correct since V1 always used the "Notes" subfolder
                print("import!")
            }
        }
        .padding()
        .frame(maxWidth: 350)
    }
}

struct ImportWindowView_Previews: PreviewProvider {
    static var previews: some View {
        ImportWindowView()
    }
}
