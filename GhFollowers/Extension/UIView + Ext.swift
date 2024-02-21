//
//  UIView + Ext.swift
//  GhFollowers
//
//  Created by Porori on 2/21/24.
//

import UIKit

extension UIView {
    // addSubviews(_ views: UIView...) doesn't work. The reason behind is how Variadic parameter work??? >> Now it works?
//    func addSubviews(_ views: [UIView]) {
//        for view in views {
//            addSubview(view)
//        }
//    }
    
    // add numerous views on to the view.
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
