//
//  GFItemInfoVC.swift
//  GhFollowers
//
//  Created by Porori on 2/16/24.
//

import UIKit

class GFItemInfoVC: UIViewController {

    let stackView = UIStackView()
    let firstItemInfoView = GFItemInfoView()
    let secondItemInfoView = GFItemInfoView()
    let actionButton = GFButton() // basic button initialized initially. We don't know what colors the content will be YET
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        layoutUI()
        configureStackView()
    }
    
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        [firstItemInfoView, secondItemInfoView].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func layoutUI() {
        [stackView, actionButton].forEach{ view.addSubview($0) }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
