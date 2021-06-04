//
//  String.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }

    func localized(_ args: CVarArg...) -> String {
        return String(format: localized, args)
    }

}
