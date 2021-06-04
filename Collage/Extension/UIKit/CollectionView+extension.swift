//
//  CollectionView+extension.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

extension UICollectionView {

    func dequeueCell<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.classIdentifier,
                                                  for: indexPath) as? Cell else {
            fatalError("Unable to dequeue cell of type \(Cell.Type.self) with indentifier \(Cell.classIdentifier)")
        }
        return cell
    }

    func registerCell<Cell: UICollectionViewCell>(with type: Cell.Type) {
        self.register(type, forCellWithReuseIdentifier: type.classIdentifier)
    }

}
