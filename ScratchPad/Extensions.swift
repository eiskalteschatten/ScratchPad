//
//  Extensions.swift
//  ScratchPad
//
//  Created by Alex Seifert on 09.12.22.
//

import Foundation

extension NSAttributedString {
    func rtfd() throws -> Data {
        try data(from: .init(location: 0, length: length),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf,
                                 .characterEncoding: String.Encoding.utf8])
    }
}
