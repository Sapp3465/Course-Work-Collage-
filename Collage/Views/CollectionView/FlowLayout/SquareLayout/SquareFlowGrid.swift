//
//  SquareFlowGrid.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

extension SquareCollectionViewFlowLayout {

    struct Grid {

        typealias LayoutSpacing = (vertical: CGFloat, horisontal: CGFloat)

        let logicalColums: Int = 3

        var spacing: LayoutSpacing {
            return (vertical: 5, horisontal: 5)
        }

    }

}
