//
//  UIHelper.swift
//  GhFollowers
//
//  Created by Porori on 2/8/24.
//

import UIKit

// reason behind chaning struct into enums > Structs allow developers to initialize the struct. Which in our case isn't what we would like the developers to do. Thus changing it into Enum allows dev-friendly approach to code. More to be explained in enum vs struct
enum UIHelper {
    
    static func createThreeColumnFlowlayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        return flowLayout
    }
}
