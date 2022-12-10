//
//  ImportWindowView.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import SwiftUI

struct ImportWindowView: View {
    @ObservedObject private var noteModel = NoteModel()
    @ObservedObject private var settingsModel = SettingsModel()
    
    @State private var importing = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("This importer will import your notes and settings from ScratchPad version 1.x.")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("Press the Import button to continue.")
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            if !importing {
                Button("Import") {
                    startImportFromV1()
                }
            }
            else {
                ProgressView()
                    .controlSize(.small)
            }
        }
        .padding()
        .frame(maxWidth: 350)
    }
    
    private func startImportFromV1() {
        importing = true
        
        // TODO:
        // 1. Check if there is a ScratchPad folder in Application Support
        // 2. If so, import the settings
        // 3. Make sure the storage location is correct since V1 always used the "Notes" subfolder
        
        let fileManager = FileManager.default
        let realHomeDirectoryURL = realHomeDirectory()
        
        guard let locationURL = realHomeDirectoryURL?.appendingPathComponent("Library/Application Support/ScratchPad") else {
            ErrorHandling.showErrorToUser("An older version of ScratchPad could not be found.")
            importing = false
            return
        }
        
        
        // MARK: Import Preferences
        let preferencesURL = locationURL.appendingPathComponent("Preferences")
        let floatAboveWindowsURL = preferencesURL.appendingPathComponent("FloatAboveWindows.txt")
        let rememberPageNumberURL = preferencesURL.appendingPathComponent("RememberPageNumber.txt")
        let showPageNumberBoxURL = preferencesURL.appendingPathComponent("ShowPageNumberBox.txt")
        let syncDropBoxLocationURL = preferencesURL.appendingPathComponent("SyncDropBoxLocation.txt")
        let transparencyURL = preferencesURL.appendingPathComponent("Transparency.txt")
        
        do {
            let floatAboveWindows = try String(contentsOf: floatAboveWindowsURL, encoding: .utf8)
//            settingsModel.floatAboveOtherWindows = floatAboveWindows === "YES"
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
        
        
        // MARK: Import Notes
        let notesURL = locationURL.appendingPathComponent("Notes")
        
        do {
            
        } catch {
            print(error)
            ErrorHandling.showErrorToUser(error.localizedDescription)
        }
        
        importing = false
    }
}

struct ImportWindowView_Previews: PreviewProvider {
    static var previews: some View {
        ImportWindowView()
    }
}
