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
    @EnvironmentObject var storageLocationModel: StorageLocationModel
    
    @State private var importing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                Text("This importer will guide you through importing your notes and settings from ScratchPad 1.x.")
                    .lineLimit(nil)
                
                Spacer()
                
                Button (action: {
                    commandsModel.importSheetOpen = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }
            
            Text("Due to modern macOS security, it is not possible to automatically import from ScratchPad 1.x. Please follow the steps below to proceed.")
                .font(.system(size: 12))
                .lineLimit(nil)
            
            Text("Note: The imported notes will be added after any notes that currently exist in ScratchBook. No existing notes will be deleted, modified or overwritten.")
                .italic()
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
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canCreateDirectories = false
        let response = openPanel.runModal()
        
        if response == .OK {
            guard let backupURL = openPanel.url else {
                importing = false
                return
            }
            
            let notesURL = backupURL.appendingPathComponent("Notes")
            let preferencesURL = backupURL.appendingPathComponent("Preferences")
            let floatAboveWindowsURL = preferencesURL.appendingPathComponent("FloatAboveWindows.txt")
            let syncDropBoxURL = preferencesURL.appendingPathComponent("SyncDropBox.txt")
            let transparencyURL = preferencesURL.appendingPathComponent("Transparency.txt")
            
            do {
                // MARK: import settings
                let floatAboveWindows = try String(contentsOf: floatAboveWindowsURL, encoding: .utf8)
                settingsModel.floatAboveOtherWindows = floatAboveWindows == "YES"
                
                let transparency = try String(contentsOf: transparencyURL, encoding: .utf8)
                if let windowTransparency = Double(transparency) {
                    settingsModel.windowTransparency = windowTransparency
                }
                
                                
                // MARK: import notes
                if let storageLocation = storageLocationModel.storageLocation {
                    NoteManager.importNotes(from: notesURL, to: storageLocation)
                }
                noteModel.openNote()
                
                
                // MARK: sync DropBox prompt
                let syncDropBox = try String(contentsOf: syncDropBoxURL, encoding: .utf8)
                if syncDropBox == "YES" {
                    let alert = NSAlert()
                    alert.messageText = String(localized: "ScratchPad version 1.x is using currently syncing to DropBox.")
                    alert.informativeText = String(localized: "Due to modern macOS security, this setting cannot be imported. Your notes have been imported into ScratchPad, but you will have to re-select your DropBox location in the Settings.")
                    alert.addButton(withTitle: String(localized: "Open Settings..."))
                    alert.addButton(withTitle: String(localized: "OK"))
                    alert.alertStyle = .informational
                    
                    let response = alert.runModal()
                    
                    if response == .alertFirstButtonReturn {
                        if #available(macOS 13, *) {
                            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                        } else {
                            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                        }
                    }
                }
                
                
                // MARK: delete the backup folder
                try FileManager.default.removeItem(atPath: backupURL.path)
                
                
                // MARK: inform the user that everything was successful
                let alert = NSAlert()
                alert.messageText = String(localized: "Your notes were successfully imported!")
                alert.informativeText = String(localized: "Your imported notes will appear after the last page of the notes that were already in ScratchBook.")
                alert.addButton(withTitle: String(localized: "OK"))
                alert.alertStyle = .informational
                alert.runModal()
           } catch {
               print(error)
               ErrorHandling.showErrorToUser(error.localizedDescription)
           }
        }
        
        importing = false
        commandsModel.importSheetOpen = false
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}
