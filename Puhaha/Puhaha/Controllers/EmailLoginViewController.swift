//
//  EmailLoginViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/20.
//

import UIKit
import Firebase
import FirebaseAuth

class EmailLoginViewController: UIViewController {
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 주소"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .clear
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    private let nextButton: CustomedLoginButton = {
        let button = CustomedLoginButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemYellow
        
        button.addTarget(self,
                         action: #selector(nextButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.becomeFirstResponder()

        [emailLabel, passwordLabel, emailTextField, passwordTextField, errorMessageLabel, nextButton].forEach {
            view.addSubview($0)
        }
        configureConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailTextField.setUnderLine()
        passwordTextField.setUnderLine()
    }
    
    @objc private func nextButtonTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] authResult, error in
            guard let self = self else {return}
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정 -> 해당 이메일로 바로 login 진행
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                // error가 없다면 main으로 넘어간다.
                return
            }
        }
    }
    
    private func loginUser(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else {return}
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                // error가 없다면 main으로 넘어간다.
                return
            }
        }
    }
    
    private func configureConstraints() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.widthAnchor.constraint(equalToConstant: 346).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 177).isActive = true
        
        emailTextField.widthAnchor.constraint(equalToConstant: 346).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20).isActive = true
        
        passwordLabel.widthAnchor.constraint(equalToConstant: 346).isActive = true
        passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalToConstant: 346).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 20).isActive = true
        
        errorMessageLabel.widthAnchor.constraint(equalToConstant: 346).isActive = true
        errorMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorMessageLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 50).isActive = true
    }
}

extension EmailLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 입력 완료 후, 키보드가 내려가는 동작
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
        // 둘 다 값이 들어오면, nextButton 활성화
    }
}

extension UITextField {
    // textfield 하단에 밑줄 추가
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
