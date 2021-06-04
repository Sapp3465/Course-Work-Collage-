//
//  PagingFlowLayout.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/30/21.
//

import UIKit

class PagingCollectionViewFlowLayout: UICollectionViewFlowLayout {

    //MARK: - Private API
 
    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height //+ (insets.top + insets.bottom)
    }

    // MARK: - CELL
    private var cellSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }
        return collectionView.bounds.size
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
                addLayout(for: cellFrame, at: indexPath)
                cellFrame.origin.x += cellSize.width
                contentWidth = cellFrame.origin.x

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
