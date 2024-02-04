//
//  UIViewController+Extension.swift
//  GhFollowers
//
//  Created by Porori on 2/4/24.
//

import UIKit

extension UIViewController {
    
    // To reduce movement to Main Thread every single call site, 항상 MainThread에 발생할 수 있도록 extension에서 처리
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }
}
