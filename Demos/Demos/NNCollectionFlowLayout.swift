//
//  NNCollectionFlowLayout.swift
//  Demos
//
//  Created by tenroadshow on 7.1.22.
//

import Foundation
import UIKit


@objc protocol NNCollectionViewFlowLayoutDelegate: NSObjectProtocol {
    // 通过itemW获取itemH
    func heightForRow(indexPath: IndexPath, itemW: CGFloat) -> CGFloat
        
    // section对应的组有几列
    @objc optional func numberOfColum(section: Int) -> Int
    
    // section对应组的contentInset
    @objc optional func contentInset(section: Int) -> UIEdgeInsets
    
    // section对应组的lineSpacing
    @objc optional func lineSpacing(section: Int) -> CGFloat
    
    // section对应组的columSpacing
    @objc optional func columSpacing(section: Int) -> CGFloat
 
    
    @objc optional func headerSize(section: Int) -> CGSize
    
    @objc optional func footerSize(section: Int) -> CGSize
    
}



class NNCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    
    fileprivate var attributes: [UICollectionViewLayoutAttributes] = []
    
    // 内容的总体高度
    fileprivate var contentHeight: CGFloat = .zero
    
    // 有多少组
    fileprivate var numberOfSection: Int = 1
    
    // 记录上一组高度最高的一列的高度
    fileprivate var lastContentHeight: CGFloat = 0.0
    
    // 记录所有组的总高度
    fileprivate var columnHeights: [CGFloat] = []
    
    
    
    fileprivate var headerSize: CGSize = .zero
    fileprivate var footerSize: CGSize = .zero
    fileprivate var headerFooterSpace: CGFloat = 0

    // 代理
    public var delegate: NNCollectionViewFlowLayoutDelegate?
    
    // 布局前的准备
    override func prepare() {
        super.prepare()
        guard let associatedCollectionView = collectionView else { return }

        lastContentHeight = 0
        
        numberOfSection = associatedCollectionView.numberOfSections

        // 2. 每组进行布局
        for section  in 0..<numberOfSection {
            let indexPath = IndexPath(row: 0, section: section)
            // 找到当前组有几列: 至少有一列
            var numberOfColum: Int = 1
            if let colum = delegate?.numberOfColum?(section: indexPath.section) {
                numberOfColum = max(1, colum)
            }

            // header
            let headerAttribute = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            if let headerAttribute = headerAttribute {
                attributes.append(headerAttribute)
                columnHeights.removeAll()
            }
            lastContentHeight = contentHeight
            
            for _ in 0..<numberOfColum {
                columnHeights.append(contentHeight)
            }
            
            let numberOfItems: Int = associatedCollectionView.numberOfItems(inSection: indexPath.section)
            for index in 0..<numberOfItems {
                let idxPath = IndexPath(row: index, section: indexPath.section)
                let attribute = layoutAttributesForItem(at: idxPath)
                if let attribute = attribute {
                    attributes.append(attribute)
                }
            }
            
            // footer
            let footerAttribute = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
            if let footerAttribute = footerAttribute {
                attributes.append(footerAttribute)
            }
        }
    }
    
    
    // 返回布局内容的尺寸
    override var collectionViewContentSize: CGSize {
        guard let associatedCollectionView = collectionView else { return .zero }
        return CGSize(width: associatedCollectionView.frame.size.width,
                      height: contentHeight)
    }
    
    
    // 返回attribute数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    

    // 返回单个attribute
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let associatedCollectionView = collectionView else { return super.layoutAttributesForItem(at: indexPath) }
        
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        // 找到当前组的contentInset
        var currentContentInset: UIEdgeInsets = .zero
        if let contentInset = delegate?.contentInset?(section: indexPath.section) {
            currentContentInset = contentInset
        }
        let contentW: CGFloat = associatedCollectionView.frame.size.width - currentContentInset.left - currentContentInset.right
        
        // 找到当前组有几列
        var numberOfColum: Int = 2
        if let colum = delegate?.numberOfColum?(section: indexPath.section) {
            numberOfColum = max(1, colum)
        }
        var columSpace: CGFloat = 10
        if let space = delegate?.columSpacing?(section: indexPath.section) {
            columSpace = space
        }
        var lineSpace: CGFloat = 10
        if let space = delegate?.lineSpacing?(section: indexPath.section) {
            lineSpace = space
        }

        
        // 单个cell的宽度
        let itemW: CGFloat = (contentW - CGFloat(numberOfColum - 1) * columSpace) / CGFloat(numberOfColum)
        
        var itemH:CGFloat = 0
        if let height = delegate?.heightForRow(indexPath: indexPath, itemW: itemW) {
            itemH = max(0.1, height)
        }
        
        
        var tmpMinColumn = 0
        var minColumnHeight = columnHeights[0]
        
        for idx in 0..<numberOfColum {
            let columHeight = columnHeights[idx]
            if minColumnHeight > columHeight {
                minColumnHeight = columHeight
                tmpMinColumn = idx
            }
        }
        
        let itemX: CGFloat = currentContentInset.left + CGFloat(tmpMinColumn) * (itemW + columSpace)

        
//        let cellX = self.sectionInsets.left + CGFloat(tmpMinColumn) * (cellWeight + self.interitemSpacing)

        
        var itemY = minColumnHeight
        if itemY != lastContentHeight {
            itemY += lineSpace
        }
        
        contentHeight = max(contentHeight, minColumnHeight)
        attribute.frame = CGRect(x: itemX,
                                 y: itemY,
                                 width: itemW,
                                 height: itemH)

        columnHeights[tmpMinColumn] = attribute.frame.maxY
        
        for i in 0..<columnHeights.count {
            contentHeight = max(contentHeight, columnHeights[i])
        }
        return attribute
    }
    
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        var currentInset: UIEdgeInsets = .zero
        if let inset = delegate?.contentInset?(section: indexPath.section) {
            currentInset = inset
        }

        if elementKind == UICollectionView.elementKindSectionHeader {
            if let headerSize = delegate?.headerSize?(section: indexPath.section) {
                self.headerSize = headerSize
            }
            contentHeight += headerFooterSpace
            attribute.frame = CGRect(x: 0, y: contentHeight, width: headerSize.width, height: headerSize.height)
            contentHeight += headerSize.height
            contentHeight += currentInset.top
        }else if elementKind == UICollectionView.elementKindSectionFooter {
            if let footerSize = delegate?.footerSize?(section: indexPath.section) {
                self.footerSize = footerSize
            }
            contentHeight += currentInset.bottom
            attribute.frame = CGRect(x: 0, y: contentHeight,
                                     width: footerSize.width,
                                     height: footerSize.height)
            contentHeight += footerSize.height
        }
        return attribute
    }
}

