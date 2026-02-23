//
//  UserDefaultsConfig.swift
//  ScratchPad
//
//  Created by Benjamin Seifert on 23.02.26.
//

final class UserDefaultsConfig {
    #if DEBUG
    static var storageLocationBookmarkData = "storageLocationBookmarkData-debug"
    static var windowTransparency = "windowTransparency-debug"
    static var floatAboveOtherWindows = "floatAboveOtherWindows-debug"
    static var openWelcomeSheetOnLaunch = "openWelcomeSheetOnLaunch-debug"
    static var pageNumber = "pageNumber-debug"
    #else
    static var storageLocationBookmarkData = "storageLocationBookmarkData"
    static var windowTransparency = "windowTransparency"
    static var floatAboveOtherWindows = "floatAboveOtherWindows"
    static var openWelcomeSheetOnLaunch = "openWelcomeSheetOnLaunch-debug"
    static var pageNumber = "pageNumber"
    #endif
}
