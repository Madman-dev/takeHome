//
//  UITableView + Ext.swift
//  GhFollowers
//
//  Created by Porori on 2/21/24.
//

import UIKit

extension UITableView {
    func removeExcessiveCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
