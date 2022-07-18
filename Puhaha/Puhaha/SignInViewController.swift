//
//  SignInViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/18.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    private let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "🍚 밥 먹언?"
      label.textColor = .black
      label.font = .systemFont(ofSize: 24)
      return label
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("애플로 가입하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(appleLoginButton)
        configureConstraints()
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    }
}
