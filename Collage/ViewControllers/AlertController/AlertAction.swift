//
//  AlertAction.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import UIKit

struct AlertAction {

    enum Priority {
        case normal
        case hight
        case low
    }

    let priority: Priority
    let message: String
    let action: (() -> Void)?

}
