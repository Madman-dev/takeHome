//
//  GFEmptyStateView.swift
//  GhFollowers
//
//  Created by Porori on 2/13/24.
//

import UIKit

class GFEmptyStateView: UIView {
    
    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configure() {
        [messageLabel, logoImageView].forEach{ addSubview($0) }
        
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        logoImageView.image = Images.emptyState
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // change position of labels according to Screen height
        let labelCenterYConstrant: CGFloat = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed ? -80 : -150
        let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstrant)
        messageLabelCenterYConstraint.isActive = true
        
        let logoImageBottomConstant: CGFloat = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed ? 120 : 40
        let logoImageViewBottomConstraint = logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoImageBottomConstant)
        logoImageViewBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170)
        ])
    }
}
