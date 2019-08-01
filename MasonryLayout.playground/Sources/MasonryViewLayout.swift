//
//  MasonryViewLayout.swift
//  MasonryLayout
//
//  Created by Hsiao, Wayne on 2019/7/31.
//  Copyright © 2019 com.wayne.hsiao. All rights reserved.
//

import UIKit

public protocol MasonryViewDelegateLayout: class {
    var numberOfColums: Int { get }
    var interItemSpacing: CGFloat { get }
    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        heightForItemAtIndexPath: IndexPath) -> CGFloat
}

public class MasonryViewLayout: UICollectionViewLayout {
    var numberOfColumns: Int {
        return delegate.numberOfColums
    }
    var interItemSpacing: CGFloat {
        return delegate.interItemSpacing
    }

    /// [Column: ValueForY]
    var lastYValueForColumns = [Int: CGFloat]()
    var layoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    weak var delegate: MasonryViewDelegateLayout!

    public required init(delegate: MasonryViewDelegateLayout) {
        super.init()
        self.delegate = delegate
    }

    private override init() {
        super.init()
        fatalError("init(coder:) has not been implemented")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func availableSpaceExcludePadding() -> CGFloat {
        let fullWidth = collectionView!.frame.size.width
        let availableSpaceExcludePadding = fullWidth - interItemSpacing * (CGFloat(numberOfColumns) + 1)
        return availableSpaceExcludePadding
    }

    override public func prepare() {
        layoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
        lastYValueForColumns = [Int: CGFloat]()
        var currentColumn = 0
        let itemWidth = availableSpaceExcludePadding() / CGFloat(numberOfColumns)
        var _: NSIndexPath!

        let numberOfSections = collectionView!.numberOfSections
        for section in 0...numberOfSections - 1 {
            let numberOfItems = collectionView!.numberOfItems(inSection: section)
            for item in 0...numberOfItems - 1 {
                let indexPath = IndexPath(item: item, section: section)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let x = interItemSpacing + (interItemSpacing + itemWidth) * CGFloat(currentColumn)
                let lastYValue = lastYValueForColumns[currentColumn] ?? 0
                let height = delegate.collectionView(collectionView!, layout: self, heightForItemAtIndexPath: indexPath)
                itemAttributes.frame = CGRect(x: x, y: lastYValue, width: itemWidth, height: height)
                lastYValueForColumns[currentColumn] = lastYValue + height + interItemSpacing
                // Calculate the next column.
                currentColumn = currentColumn + 1
                // Calculate first column if reach the boundary.
                if currentColumn == numberOfColumns {
                    currentColumn = 0
                }
                layoutInfo[indexPath] = itemAttributes
            }
        }
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutInfo.compactMap { (key: IndexPath, attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes? in
            if rect.intersects(attributes.frame) {
                return attributes
            } else {
                return nil
            }
        }
    }

    override public var collectionViewContentSize: CGSize {
        let maxHeight = lastYValueForColumns.map { $0.value }.sorted(by: >).first ?? 0
        return CGSize(width: collectionView!.frame.size.width, height: maxHeight)
    }
}
