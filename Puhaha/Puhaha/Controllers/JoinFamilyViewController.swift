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
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.isHidden = true
        return label
    }()
    
    lazy var familyCodeTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let dividerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
               
                if self.isExistedFamily {
                    self.setButtonEnable(true)
                    self.resultTextLabel.text = "유효한 가족 코드입니다"
                    self.resultTextLabel.textColor = .systemGreen
                    self.dividerView.backgroundColor = UIColor.systemGreen
                } else {
                    self.setButtonEnable(false)
                    self.resultTextLabel.text = "존재하지 않는 가족 코드입니다"
                    self.resultTextLabel.textColor = .red
                    self.dividerView.backgroundColor = UIColor.red
                }
            }
        } else {
            self.setButtonEnable(false)
            self.resultTextLabel.isHidden = true
            self.dividerView.backgroundColor = UIColor.lightGray
        }
    }
    
    private func setButtonEnable(_ isEnabled: Bool) {
        self.nextButton.isUserInteractionEnabled = isEnabled
        
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
        let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") as String? ?? ""

        UserDefaults.standard.set(joinedRoomCode, forKey: "roomCode")
        let mainTabViewController = MainTabViewController()
        self.navigationController?.pushViewController(mainTabViewController, animated: true)
        
        firestoreManager.addFamilyMember(roomCode: joinedRoomCode, userIdentifier: userIdentifier)
        firestoreManager.setFamilyCode(userIdentifier: userIdentifier, code: joinedRoomCode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(false, animated: false)
        familyCodeTextField.becomeFirstResponder()
        
        [guidingTextLabel, familyCodeTextField, dividerView, nextButton, resultTextLabel].forEach {
            view.addSubview($0)
        }
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        familyCodeTextField.delegate = self
    }
    
    private func configureConstraints() {
        guidingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        familyCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        resultTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guidingTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guidingTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2).isActive = true
        guidingTextLabel.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        
        familyCodeTextField.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        familyCodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        familyCodeTextField.topAnchor.constraint(equalTo: guidingTextLabel.bottomAnchor, constant: view.bounds.height * 0.04).isActive = true
        
        dividerView.leadingAnchor.constraint(equalTo: familyCodeTextField.leadingAnchor).isActive = true
        dividerView.trailingAnchor.constraint(equalTo: familyCodeTextField.trailingAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 844).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: familyCodeTextField.bottomAnchor, constant: UIScreen.main.bounds.height / 100).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: familyCodeTextField.bottomAnchor, constant: view.bounds.height * 0.55).isActive = true
        
        resultTextLabel.topAnchor.constraint(equalTo: familyCodeTextField.bottomAnchor, constant: 10).isActive = true
        resultTextLabel.leadingAnchor.constraint(equalTo: familyCodeTextField.leadingAnchor).isActive = true
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
