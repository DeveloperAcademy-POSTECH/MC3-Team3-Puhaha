//
//  SignInViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/18.
//

import UIKit
import FirebaseFirestore
import AuthenticationServices

class SignInViewController: UIViewController {
    
    public var db = Firestore.firestore()
    public var currentNonce: String?
    public var user = Users()
    
    private let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "밥 먹언?"
      label.textColor = .black
      label.font = .systemFont(ofSize: 40, weight: .ultraLight)
      return label
    }()
    
    private let guidingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "간편하게 로그인하고 \n 다양한 서비스를 이용해보세요"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.setLineHeight(lineHeight: 1.52)
        return label
    }()

    lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .default, style: .white)
        button.widthAnchor.constraint(equalToConstant: 338).isActive = true
        button.heightAnchor.constraint(equalToConstant: 57).isActive = true
        button.addTarget(self,
                         action: #selector(appleLoginButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customYellow
        navigationController?.setNavigationBarHidden(true, animated: false)

        [titleLabel, guidingTextLabel, appleLoginButton].forEach {
            view.addSubview($0)
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        guidingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.3).isActive = true
        
        guidingTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        guidingTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guidingTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: view.bounds.height * 0.02).isActive = true

        appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleLoginButton.topAnchor.constraint(equalTo: guidingTextLabel.bottomAnchor, constant: view.bounds.height * 0.15).isActive = true
    }
}

extension SignInViewController {
    @objc func appleLoginButtonTapped() {
        startSignInWithAppleFlow()
    }
}
