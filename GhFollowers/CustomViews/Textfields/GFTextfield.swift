//
//  GFTextfield.swift
//  GhFollowers
//
//  Created by Porori on 2/2/24.
//

import UIKit

class GFTextfield: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(withSpace: Bool) {
        self.init(frame: .zero)
        addSpacing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius  = 10
        layer.borderWidth   = 2
        layer.borderColor   = UIColor.systemGray4.cgColor
        
        textColor           = .label
        tintColor           = .label
        textAlignment       = .left
        font                = UIFont.preferredFont(forTextStyle: .title2)
        minimumFontSize     = 12
        adjustsFontSizeToFitWidth = true
        
        backgroundColor     = .tertiarySystemBackground
        autocorrectionType  = .no
        clearButtonMode     = .whileEditing
        
        placeholder         = "Enter a username"
        returnKeyType       = .go
    }
    
    // indent at beginning
    private func addSpacing() {
        let paddingView = UIView(frame: CGRect(x: 0, y: -10, width: 10, height: 50))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

#Preview {
    GFTextfield()
}
