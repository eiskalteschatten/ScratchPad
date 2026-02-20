//
//  SettingsWindowView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import SwiftUI
import Sparkle

struct SettingsWindowView: View {
    @EnvironmentObject private var settingsModel: SettingsModel
    
    @FocusState private var transTextfieldIsFocused: Bool
    
    private let updater: SPUUpdater
    @State private var automaticallyCheckForUpdates: Bool
    
    private let labelColumnWidth: CGFloat = 150
    
    init(updater: SPUUpdater) {
        self.updater = updater
        automaticallyCheckForUpdates = updater.automaticallyChecksForUpdates
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Group {
                HStack(alignment: .top, spacing: 15) {
                    Text("Updates:")
                        .frame(width: labelColumnWidth, alignment: .trailing)
                    
                    Toggle("Automatically check for updates", isOn: $automaticallyCheckForUpdates)
                }
            }
            Group {
                HStack(alignment: .top, spacing: 15) {
                    Text("Window Transparency:")
                        .frame(width: labelColumnWidth, alignment: .trailing)
                    
                    Slider(value: Binding<Double>(
                        get: { settingsModel.windowTransparency },
                        set: {
                            settingsModel.windowTransparency = $0
                            transTextfieldIsFocused = false
                        }
                    ), in: 0...100)
                    
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
                            .focused($transTextfieldIsFocused)
                            .frame(width: 50)
                        
                        Text("%")
                    }
                }
            }
            Group {
                HStack(alignment: .top, spacing: 15) {
                    Text("Floating:")
                        .frame(width: labelColumnWidth, alignment: .trailing)
                    
                    Toggle("Float above other windows", isOn: $settingsModel.floatAboveOtherWindows)
                }
            }
            Group {
                HStack(alignment: .top, spacing: 15) {
                    Text("Storage Location:")
                        .frame(width: labelColumnWidth, alignment: .trailing)
                    
                    VStack(alignment: .leading) {
                        Text(settingsModel.formattedStorageLocation ?? "No storage location selected")
                        Button("Change Storage Location...", action: selectStorageLocation)
                        Button("Use Default Storage Location", action: settingsModel.resetStorageLocation)
                    }
                }
            }
        }
        .padding()
        .onChange(of: automaticallyCheckForUpdates) { _, newValue in
            updater.automaticallyChecksForUpdates = newValue
        }
    }
    
    private func selectStorageLocation() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canCreateDirectories = true
        let response = openPanel.runModal()
        
        if response == .OK {
            settingsModel.storageLocation = openPanel.url
        }
    }
}

struct SettingsWindowView_Previews: PreviewProvider {
    private static let updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    
    static var previews: some View {
        SettingsWindowView(updater: updaterController.updater)
    }
}
