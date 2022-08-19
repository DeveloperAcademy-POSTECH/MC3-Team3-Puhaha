//
//  NameEditingViewController.swift
//  Puhaha
//
//  Created by Lena on 2022/08/19.
//

import UIKit

import FirebaseFirestore

class NameEditingViewController: UIViewController {
    private var db = Firestore.firestore()
    
    private let guidingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "가족에게 보여질 이름을 입력해주세요"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .clear
        return textField
    }()
    
    lazy var nextButton: CustomedButton = {
        let button = CustomedButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.customYellow
        button.addTarget(self,
                         action: #selector(nextButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    @objc private func nextButtonTapped() {
        let signinUserName = nameTextField.text as String? ?? ""
        let signinUserEmail = UserDefaults.standard.string(forKey: "loginedUserEmail") as String? ?? "-"
        let firestoreManager = FirestoreManager()

        UserDefaults.standard.set(signinUserName, forKey: "name")
        firestoreManager.setUserName(userEmail: signinUserEmail, userName: signinUserName)
        let accountSettingViewController = AccountSettingViewController()
        self.navigationController?.pushViewController(accountSettingViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(false, animated: false)
        nameTextField.becomeFirstResponder()
        
        [guidingTextLabel, nameTextField, nextButton].forEach {
            view.addSubview($0)
        }
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameTextField.delegate = self
        nameTextField.setUnderLine()
    }
    
    private func configureConstraints() {
        guidingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        guidingTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guidingTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2).isActive = true
        guidingTextLabel.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: guidingTextLabel.bottomAnchor, constant: view.bounds.height * 0.04).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: view.bounds.height * 0.55).isActive = true
    }
}

extension NameEditingViewController: UITextFieldDelegate {
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         view.endEditing(true)
         return false
     }

     func textFieldDidEndEditing(_ textField: UITextField) {
         let isNameEmpty = nameTextField.text == ""
         nextButton.isEnabled = !isNameEmpty
     }
 }
