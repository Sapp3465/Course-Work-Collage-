//
//  SquareCollectionViewFlowLayout.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

class SquareCollectionViewFlowLayout: UICollectionViewFlowLayout {

    //MARK: - Private API

    private let grid = Grid()
 
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    private var contentHeight: CGFloat = 0

    // MARK: - CELL
    private var cellSize: CGSize {

        let totolRowSplits = CGFloat(grid.logicalColums - 1)

        let totolRowSpacing = totolRowSplits * grid.spacing.horisontal
        let widthForCells = contentWidth - totolRowSpacing
        let cellSide = widthForCells / CGFloat(grid.logicalColums)

        return CGSize(width: cellSide, height: cellSide)
    }

    public override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = self.collectionView else {
            return
        }

        layoutCache.removeAll()

        var cellFrame = CGRect(origin: .zero, size: self.cellSize)

        for sectionNumber in 0..<collectionView.numberOfSections {
            for rowNumber in 0..<collectionView.numberOfItems(inSection: sectionNumber) {

                let indexPath = IndexPath(row: rowNumber, section: sectionNumber)

                switch (rowNumber + 1) % grid.logicalColums {
                case 1, 2:
                    addLayout(for: cellFrame, at: indexPath)
                    cellFrame.origin.x += cellSize.width + grid.spacing.horisontal

                case 0:
                    addLayout(for: cellFrame, at: indexPath)
                    cellFrame.origin.y += cellSize.height + grid.spacing.vertical
                    cellFrame.origin.x = 0
                    contentHeight = cellFrame.origin.y + cellSize.height + grid.spacing.vertical

                default:
                    continue
                }

            }
        }
        
    }

    // MARK: - LAYOUT
    private var layoutCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        if layoutCache.isEmpty {
            prepare()
        }
        for (_, layoutAttributes) in layoutCache {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        return layoutAttributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutCache[indexPath]
    }

    private func addLayout(for rect: CGRect, at idx: IndexPath) {

        let targetLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: idx)
        targetLayoutAttributes.frame = rect
        layoutCache[idx] = targetLayoutAttributes

    }

}
