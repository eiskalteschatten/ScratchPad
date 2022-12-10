//
//  ImportWindow.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import Cocoa
import SwiftUI

class ImportWindowManager {
    private var window: NSWindow?

    func openWindow() {
        let contentView = ImportWindowView()

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 700),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        window!.center()
        window!.setFrameAutosaveName("ImportFromOldVersion")
        window!.isReleasedWhenClosed = false
        window!.title = "Import from ScratchPad"

        window!.contentView = NSHostingView(rootView: contentView)
        window!.makeKeyAndOrderFront(nil)
    }
}
