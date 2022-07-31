//
//  NameSettingViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/31.
//

import UIKit
import FirebaseFirestore

// TODO: 가입한 사용자의 이메일 -> User가 입력한 이름 (guidingTextLabel.text)를 Users.name에 넣어준다.

class NameSettingViewController: UIViewController {
    private var database = Firestore.firestore()
    private var user = Users.self
    
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
    
    private let nextButton: CustomedButton = {
        let button = CustomedButton()
        button.setTitle("나만의 도구 제작하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.customYellow
        
        button.addTarget(self,
                         action: #selector(nextButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    // TODO: firestore 코드 외부 파일로 빼기
    @objc private func nextButtonTapped() {
        let usersName = nameTextField.text
        UserDefaults.standard.set(usersName, forKey: "name")
        database
        let pokeToolCustomizingViewController = PokeToolCustomizingViewController()
        self.navigationController?.pushViewController(pokeToolCustomizingViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(true, animated: false)
        nameTextField.becomeFirstResponder()
        
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
        guidingTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.2).isActive = true
        guidingTextLabel.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: guidingTextLabel.bottomAnchor, constant: view.bounds.height * 0.04).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: view.bounds.height * 0.55).isActive = true
    }
}
