//
//  SettingsWindowView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI

struct SettingsWindowView: View {
    @ObservedObject private var settingsModel = SettingsModel()
    
    private let labelColumnWidth: CGFloat = 150
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Group {
                HStack(alignment: .top, spacing: 15) {
                    Text("Window Transparency:")
                        .frame(width: labelColumnWidth, alignment: .trailing)
                    
                    Slider(value: $settingsModel.windowTransparency, in: 0...100)
                    
                    HStack {
                        TextField("", value: Binding<Double>(
                            get: { settingsModel.windowTransparency },
                            set: {
                                var finalValue = $0
                                
                                if finalValue < 0 {
                                    finalValue = 0
                                }
                                else if finalValue > 100 {
                                    finalValue = 100
                                }
                                
                                settingsModel.windowTransparency = finalValue
                            }
                        ), formatter: NumberFormatter())
                            .frame(width: 50)
                        
                        Text("%")
                    }
                }
            }
            Group {
                HStack(alignment: .top, spacing: 15) {
                    Text("Storage Location:")
                        .frame(width: labelColumnWidth, alignment: .trailing)
                    
                    VStack(alignment: .leading) {
                        Text(settingsModel.storageLocation?.absoluteString ?? "No storage location selected")
                        Button("Change Storage Location...", action: selectStorageLocation)
                        Button("Use Default Storage Location", action: settingsModel.resetStorageLocation)
                    }
                }
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
