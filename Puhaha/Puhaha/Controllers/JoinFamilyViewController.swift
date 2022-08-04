//
//  JoinFamilyViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/08/04.
//

import UIKit

class JoinFamilyViewController: UIViewController {
    
    private let guidingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "가족 코드"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private var familyCodeTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .clear
        return textField
    }()
    
    lazy var nextButton: CustomedButton = {
        let button = CustomedButton()
        button.setTitle("가족 방에 입장하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.customYellow
        
        button.addTarget(self,
                         action: #selector(nextButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    @objc private func nextButtonTapped() {
        let joinedRoomCode = familyCodeTextField.text
        UserDefaults.standard.set(joinedRoomCode, forKey: "roomCode")
        // TODO: 가족 코드 db에 입력
        let mainTabViewController = MainTabViewController()
        self.navigationController?.pushViewController(mainTabViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(true, animated: false)
        familyCodeTextField.becomeFirstResponder()
        
        [guidingTextLabel, familyCodeTextField, nextButton].forEach {
            view.addSubview($0)
        }
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        familyCodeTextField.delegate = self
        familyCodeTextField.setUnderLine()
    }
    
    private func configureConstraints() {
        guidingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        familyCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        guidingTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guidingTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2).isActive = true
        guidingTextLabel.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        
        familyCodeTextField.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        familyCodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        familyCodeTextField.topAnchor.constraint(equalTo: guidingTextLabel.bottomAnchor, constant: view.bounds.height * 0.04).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: familyCodeTextField.bottomAnchor, constant: view.bounds.height * 0.55).isActive = true
    }
    
}

extension JoinFamilyViewController: UITextFieldDelegate {
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         view.endEditing(true)
         return false
     }

     func textFieldDidEndEditing(_ textField: UITextField) {
         let isNameEmpty = familyCodeTextField.text == ""
         nextButton.isEnabled = !isNameEmpty
     }
 }
