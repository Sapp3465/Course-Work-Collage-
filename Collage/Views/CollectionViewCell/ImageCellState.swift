//
//  ImageCellState.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

extension ImageCollectioniewCell {

    enum State {
        case selected
        case normal

        var color: UIColor {
            switch self {
            case .normal:
                return .systemGray6
            case .selected:
                return .systemBlue
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .normal:
                return 2
            case .selected:
                return 8
            }
        }
    }

}
