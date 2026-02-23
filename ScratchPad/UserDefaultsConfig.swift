//
//  UserDefaultsConfig.swift
//  ScratchPad
//
//  Created by Benjamin Seifert on 23.02.26.
//

final class UserDefaultsConfig {
    #if DEBUG
    static let storageLocationBookmarkData = "storageLocationBookmarkData-debug"
    static let windowTransparency = "windowTransparency-debug"
    static let floatAboveOtherWindows = "floatAboveOtherWindows-debug"
    static let openWelcomeSheetOnLaunch = "openWelcomeSheetOnLaunch-debug"
    static let pageNumber = "pageNumber-debug"
    #else
    static let storageLocationBookmarkData = "storageLocationBookmarkData"
    static let windowTransparency = "windowTransparency"
    static let floatAboveOtherWindows = "floatAboveOtherWindows"
    static let openWelcomeSheetOnLaunch = "openWelcomeSheetOnLaunch-debug"
    static let pageNumber = "pageNumber"
    #endif
}
