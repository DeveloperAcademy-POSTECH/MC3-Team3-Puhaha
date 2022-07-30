//
//  NameSettingViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/31.
//

import UIKit

class NameSettingViewController: UIViewController {
    
    private let guidingTextLabel: UILabel = {
      let label = UILabel()
      label.text = "가족에게 보여질 이름을 입력해주세요"
      label.textColor = .black
      label.font = .systemFont(ofSize: 20, weight: .semibold)
      return label
    }()
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .clear
        return textField
    }()
    
    private let nextButton: CustomedLoginButton = {
         let button = CustomedLoginButton()
         button.setTitle("나만의 도구 제작하기", for: .normal)
         button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.customYellow

        button.addTarget(NameSettingViewController.self,
                          action: #selector(nextButtonTapped),
                          for: .touchUpInside)
         return button
     }()
    
    @objc private func nextButtonTapped() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(true, animated: false)

        [guidingTextLabel, nameTextField, nextButton].forEach {
            view.addSubview($0)
        }
        
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         nameTextField.setUnderLine()
     }
    
    private func configureConstraints() {
        guidingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        guidingTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guidingTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.3).isActive = true

        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: guidingTextLabel.bottomAnchor, constant: view.bounds.height * 0.02).isActive = true

        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: view.bounds.height * 0.15).isActive = true
    }
}

extension UITextField {
     func setUnderLine() {
         let bottomLine = CALayer()
         bottomLine.frame = CGRect(x: 0.0,
                                   y: self.bounds.height + 3,
                                   width: self.bounds.width,
                                   height: 1.5)
         bottomLine.backgroundColor = UIColor.lightGray.cgColor
         self.borderStyle = UITextField.BorderStyle.none
         self.layer.addSublayer(bottomLine)
     }
 }
