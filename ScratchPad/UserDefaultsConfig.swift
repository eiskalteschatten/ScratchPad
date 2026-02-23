//
//  UserDefaultsConfig.swift
//  ScratchPad
//
//  Created by Benjamin Seifert on 23.02.26.
//

final class UserDefaultsConfig {
    #if DEBUG
    private static let keySuffix = "-debug"
    #else
    private static let keySuffix = ""
    #endif

    static var storageLocationBookmarkData: String { "storageLocationBookmarkData\(keySuffix)" }
    static var windowTransparency: String { "windowTransparency\(keySuffix)" }
    static var floatAboveOtherWindows: String { "floatAboveOtherWindows\(keySuffix)" }
    static var openWelcomeSheetOnLaunch: String { "openWelcomeSheetOnLaunch\(keySuffix)" }
    static var pageNumber: String { "pageNumber\(keySuffix)" }
}
