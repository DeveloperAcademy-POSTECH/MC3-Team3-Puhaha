//
//  SignInViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/18.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftUI

class SignInViewController: UIViewController {
    
    private let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "🍚 밥 먹언?"
      label.textColor = .black
      label.font = .systemFont(ofSize: 32, weight: .regular)
      return label
    }()
    
    private let emailLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "mail"), for: .normal)
        button.setTitle("이메일로 가입하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "applelogo"), for: .normal)
        button.setTitle("애플로 가입하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(emailLoginButton)
        view.addSubview(appleLoginButton)
        configureConstraints()
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLoginButton.translatesAutoresizingMaskIntoConstraints = false
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        emailLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLoginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100).isActive = true
        
        appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleLoginButton.topAnchor.constraint(equalTo: emailLoginButton.bottomAnchor, constant: 50).isActive = true
    }
}
