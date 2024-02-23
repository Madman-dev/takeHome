//
//  UIViewController+Extension.swift
//  GhFollowers
//
//  Created by Porori on 2/4/24.
//

import UIKit
import SafariServices

extension UIViewController {
    
    // DispatchQueue removed with async await
    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    func presentDefaultError() {
        let alertVC = GFAlertVC(title: "뭔가 잘못됐어요",
                                message: "모르는 오류가 발견됐어요",
                                buttonTitle: "Ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .green
        present(safariVC, animated: true)
    }
}
