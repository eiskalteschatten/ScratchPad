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
            
            Text(settingsModel.storageLocation?.absoluteString ?? "No storage location selected")
                .font(.caption)
            
            HStack {
                Button("Change Storage Location...", action: selectStorageLocation)
                Button("Use Default Storage Location", action: settingsModel.resetStorageLocation)
            }
        }
        .padding()
    }
    
    private func selectStorageLocation() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        let response = openPanel.runModal()
        
        if response == .OK {
            settingsModel.storageLocation = openPanel.url
        }
    }
}

struct SettingsWindowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWindowView()
    }
}
