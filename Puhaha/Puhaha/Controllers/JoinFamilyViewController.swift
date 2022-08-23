//
//  JoinFamilyViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/08/04.
//

import UIKit

import FirebaseFirestore

class JoinFamilyViewController: UIViewController {
    private let firestoreManager: FirestoreManager = FirestoreManager()
    
    private var isExistedFamily: Bool = false
    public var db = Firestore.firestore()
    
    private let guidingTextLabel: UILabel = {
        let label = UILabel()
        label.text = "가족 코드"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let resultTextLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        label.text = "존재하지 않는 가족 코드입니다"
        label.textColor = .red
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    private var familyCodeTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private var borderBox: UIView = {
        let box = UIView()
        box.layer.borderColor = UIColor.red.cgColor
        box.layer.borderWidth = 1
        box.layer.cornerRadius = 5
        box.isHidden = true
        return box
    }()
    
    lazy var nextButton: CustomedButton = {
        let button = CustomedButton()
        button.setTitle("가족 방에 입장하기", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.backgroundColor = UIColor.customLightGray
        
        button.addTarget(self,
                         action: #selector(nextButtonTapped),
                         for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    @objc private func textFieldDidChange() {
        if familyCodeTextField.text?.count == 36 {
            firestoreManager.isExistFamily(roomCode: familyCodeTextField.text!) {
                self.isExistedFamily = self.firestoreManager.isExistFamily
                self.resultTextLabel.isHidden = false
                self.borderBox.isHidden = false
                
                if self.isExistedFamily {
                    self.setButtonEnable(true)
                    self.resultTextLabel.text = "유효한 가족 코드입니다"
                    self.resultTextLabel.textColor = .systemGreen
                    self.borderBox.layer.borderColor = UIColor.systemGreen.cgColor
                } else {
                    self.setButtonEnable(false)
                    self.resultTextLabel.text = "존재하지 않는 가족 코드입니다"
                    self.resultTextLabel.textColor = .red
                    self.borderBox.layer.borderColor = UIColor.red.cgColor
                }
            }
        } else {
            self.setButtonEnable(false)
            self.resultTextLabel.isHidden = true
            self.borderBox.isHidden = true
        }
    }
    
    private func setButtonEnable(_ isEnabled: Bool) {
        self.nextButton.isEnabled = isEnabled
        
        if isEnabled {
            self.nextButton.setTitleColor(UIColor.black, for: .normal)
            self.nextButton.backgroundColor = .customYellow
        } else {
            self.nextButton.backgroundColor = .customLightGray
            self.nextButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    @objc private func nextButtonTapped() {
        let joinedRoomCode = familyCodeTextField.text as String? ?? ""
        let userEmail = UserDefaults.standard.string(forKey: "loginedUserEmail") as String? ?? ""
        let firestoreManager = FirestoreManager()

        UserDefaults.standard.set(joinedRoomCode, forKey: "roomCode")
        let mainTabViewController = MainTabViewController()
        self.navigationController?.pushViewController(mainTabViewController, animated: true)
        
        firestoreManager.addFamilyMember(roomCode: joinedRoomCode, userEmail: userEmail)
        firestoreManager.setFamilyCode(userEmail: userEmail, code: joinedRoomCode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(false, animated: false)
        familyCodeTextField.becomeFirstResponder()
        
        [guidingTextLabel, familyCodeTextField, nextButton, borderBox, familyCodeTextField, resultTextLabel].forEach {
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
        resultTextLabel.translatesAutoresizingMaskIntoConstraints = false
        borderBox.translatesAutoresizingMaskIntoConstraints = false
        
        guidingTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guidingTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2).isActive = true
        guidingTextLabel.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        
        familyCodeTextField.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        familyCodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        familyCodeTextField.topAnchor.constraint(equalTo: guidingTextLabel.bottomAnchor, constant: view.bounds.height * 0.04).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: familyCodeTextField.bottomAnchor, constant: view.bounds.height * 0.55).isActive = true
        
        resultTextLabel.topAnchor.constraint(equalTo: familyCodeTextField.bottomAnchor, constant: 10).isActive = true
        resultTextLabel.trailingAnchor.constraint(equalTo: familyCodeTextField.trailingAnchor).isActive = true
        
        borderBox.heightAnchor.constraint(equalTo: familyCodeTextField.heightAnchor, constant: 10).isActive = true
        borderBox.widthAnchor.constraint(equalTo: familyCodeTextField.widthAnchor, constant: 10).isActive = true
        borderBox.centerXAnchor.constraint(equalTo: familyCodeTextField.centerXAnchor).isActive = true
        borderBox.centerYAnchor.constraint(equalTo: familyCodeTextField.centerYAnchor).isActive = true
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
