//
//  Files.swift
//  ScratchPad
//
//  Created by Alex Seifert on 10.12.22.
//

import Foundation

func realHomeDirectory() -> URL? {
    guard let pw = getpwuid(getuid()) else { return nil }
    return URL(fileURLWithFileSystemRepresentation: pw.pointee.pw_dir, isDirectory: true, relativeTo: nil)
}
