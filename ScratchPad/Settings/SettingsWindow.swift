//
//  PreferencesWindow.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import Cocoa
import SwiftUI

class SettingsWindowManager {
    private var window: NSWindow?
    
    func openWindow() {
        let contentView = SettingsWindowView()
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 450, height: 550),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )

        window!.center()
        window!.setFrameAutosaveName("Settings")
        window!.isReleasedWhenClosed = false
        window!.isMovableByWindowBackground  = true
        window!.titleVisibility = .hidden
        window!.titlebarAppearsTransparent = true
        window!.styleMask.insert(.fullSizeContentView)
        window!.title = "Settings"

        window!.contentView = NSHostingView(rootView: contentView)
        window!.makeKeyAndOrderFront(nil)
    }
}

