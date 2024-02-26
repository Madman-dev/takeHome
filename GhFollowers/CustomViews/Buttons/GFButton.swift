//
//  GFButton.swift
//  GhFollowers
//
//  Created by Porori on 2/2/24.
//

import UIKit
import SwiftUI

class GFButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // create with image
    convenience init(color: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: systemImageName)
    }
    
    // create without image
    convenience init(color: UIColor, title: String) {
        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // basic configuration
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium // cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(color: UIColor, title: String, systemImageName: String) { // no longer background color
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title // setting title
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading // default image
        // configuration?.buttonSize = .large
    }
}

#Preview {
    GFButton(color: .black, title: "Test Button", systemImageName: "pencil")
}
