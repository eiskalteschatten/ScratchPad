//
//  ImportWindowView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import SwiftUI

struct ImportView: View {
    @EnvironmentObject var noteModel: NoteModel
    @EnvironmentObject var settingsModel: SettingsModel
    @EnvironmentObject var commandsModel: CommandsModel
    
    @State private var importing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button (action: {
                commandsModel.importSheetOpen = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 18))
            }
            .buttonStyle(.plain)
            
            Text("This importer will guide you through importing your notes and settings from ScratchPad 1.x.")
                .lineLimit(nil)
            
            Text("Due to modern macOS security, it is not possible to automatically import from ScratchPad 1.x. Please follow the steps below to proceed.")
                .font(.system(size: 12))
                .lineLimit(nil)
            
            HStack(alignment: .top, spacing: 30) {
                HStack(alignment: .top) {
                    Image(systemName: "1.circle.fill")
                        .font(.title)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Create a backup in ScratchPad 1.x and remember its location.")
                        Image("createBackup")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    }
                }
                
                HStack(alignment: .top) {
                    Image(systemName: "2.circle.fill")
                        .font(.title)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Select the button below to choose the backup folder. The folder will be called \"ScratchPad\" and will contain two folders called \"Notes\" and \"Preferences\".")
                            .lineLimit(nil)
                        
                        Text("Select the \"ScratchPad\" folder.")
                        
                        Image("chooseScratchPadFolder")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                        
                        HStack(alignment: .center, spacing: 15) {
                            Button("Choose backup folder...") {
                                importFromV1()
                            }
                            .disabled(importing)
                            
                            if importing {
                                ProgressView()
                                    .controlSize(.small)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
        .frame(maxWidth: 800)
    }
    
    private func importFromV1() {
        importing = true
        
        // TODO:
        // 1. Allow the user to choose the exported folder
        // 2. Set the settings from the import
        // 3. Move the files to the storage location
        // 4. Prompt the user and ask if the exported folder should be deleted
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canCreateDirectories = false
        let response = openPanel.runModal()
        
        if response == .OK {
            let backupURL = openPanel.url
        }
        
        importing = false
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}
