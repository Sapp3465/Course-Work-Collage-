//
//  DocumentManagerConfiguration.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import Foundation

extension DocumentManager {

    enum Configuration {

        case photos

        var searchingTypes: Set<Document.MimeType> {
            switch self {
            case .photos:
                return [.jpeg, .png]
            }
        }

    }

}
