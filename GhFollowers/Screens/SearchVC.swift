//
//  SearchVC.swift
//  GhFollowers
//
//  Created by Porori on 2/2/24.
//

import UIKit

class SearchVC: UIViewController {

    let logoImageView = UIImageView()
    let usernameTextfield = GFTextfield()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers") // 버튼의 이름이 변경되면 다시 변경해야하는 이슈가 발생 therefore Generic Type으로 이름을 작성하는 방법도 좋을 듯하다
    var isUsernameEntered: Bool { return !usernameTextfield.text!.isEmpty }
    
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextfield()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        usernameTextfield.text = ""
    }

    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGFAlertOnMainThread(title: "유저 이름이 없습니다", message: "이름이 없어요", buttonTitle: "Ok")
            return
        }
        
        let followListVC = FollowerListVC(username: usernameTextfield.text!)
        usernameTextfield.resignFirstResponder() // remove textfield after pushing
        navigationController?.pushViewController(followListVC, animated: true)
    }
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed ? 20 : 80
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                                        constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextfield() {
        view.addSubview(usernameTextfield)
        usernameTextfield.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextfield.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextfield.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
