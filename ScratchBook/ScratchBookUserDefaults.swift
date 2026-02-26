//
//  ScratchBookUserDefaults.swift
//  ScratchPad
//
//  Created by Benjamin Seifert on 23.02.26.
//

import Foundation

final class ScratchBookUserDefaults {
    #if DEBUG
    static let defaults = UserDefaults(suiteName: "com.alexseifert.ScratchBook.debug") ?? .standard
    #else
    static let defaults = UserDefaults.standard
    #endif

    static let storageLocationBookmarkData = "storageLocationBookmarkData"
    static let windowTransparency = "windowTransparency"
    static let floatAboveOtherWindows = "floatAboveOtherWindows"
    static let openWelcomeSheetOnLaunch = "openWelcomeSheetOnLaunch"
    static let pageNumber = "pageNumber"
}
