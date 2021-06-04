//
//  Identifiable.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

extension Identifiable where Self: UIView {

    static var classIdentifier: String {
        return String(describing: Self.self)
    }

}
