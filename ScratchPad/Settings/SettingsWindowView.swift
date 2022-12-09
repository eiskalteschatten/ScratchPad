//
//  SettingsWindowView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct SettingsWindowView: View {
    @ObservedObject private var settingsModel = SettingsModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Storage Location")
                .font(.title2)
            
            Text(settingsModel.storageLocation ?? "No storage location selected")
            
            Button("Change Storage Location...", action: {
                // TODO: prompt the user to choose a folder
            })
            
        }
        .padding()
    }
}

struct SettingsWindowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWindowView()
    }
}
