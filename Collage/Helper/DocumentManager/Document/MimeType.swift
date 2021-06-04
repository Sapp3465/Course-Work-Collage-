//
//  MimeType.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import Foundation
import MobileCoreServices

extension Document {

    public enum MimeType: String, CaseIterable {

        case jpeg
        case png

        /// Determine file mime by binary pattern
        /// - Parameter pattern: data of file
        public init?(pattern: Data) {
            let mimeType: CFString = pattern.mimeType as CFString

            guard let mimeUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType, nil)?.takeUnretainedValue() else {
                return nil
            }

            guard let extUTI = UTTypeCopyPreferredTagWithClass(mimeUTI, kUTTagClassFilenameExtension)?.takeUnretainedValue() else {
                return nil
            }

            self.init(rawValue: extUTI as String)
        }

        var fileType: String? {
            guard let mimeUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, self.rawValue as CFString, nil)?.takeUnretainedValue() else {
                return nil
            }

            return mimeUTI as String
        }

        var contentType: String? {
            guard let extUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, self.rawValue as CFString, nil)?.takeUnretainedValue() else {
                return nil
            }

            guard let mimeUTI = UTTypeCopyPreferredTagWithClass(extUTI, kUTTagClassMIMEType)?.takeUnretainedValue() else {
                return nil
            }

            return mimeUTI as String
        }

    }

}
