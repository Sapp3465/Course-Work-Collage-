//
//  Data+Extension.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import Foundation

public extension Data {
    
    private static let mimeTypeSignatures: [UInt8: String] =
        [
            0xFF: "image/jpeg",
            0x89: "image/png"
        ]
    
    var mimeType: String {
        var byte: UInt8 = 0
        copyBytes(to: &byte, count: 1)
        return Data.mimeTypeSignatures[byte, default: "application/octet-stream"]
    }
    
}

