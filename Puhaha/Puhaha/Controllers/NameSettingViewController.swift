//
//  NameSettingViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/31.
//

import UIKit

import FirebaseFirestore
import FirebaseMessaging

class NameSettingViewController: UIViewController {
    private var db = Firestore.firestore()
    private var firestoreManager: FirestoreManager = FirestoreManager()
    private var userIdentifier: String = ""
    
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
        button.setTitle("나만의 도구 제작하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.customYellow
        
        button.addTarget(self,
                         action: #selector(nextButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    @objc private func nextButtonTapped() {
        let signinUserName = nameTextField.text as String? ?? ""
        let firestoreManager = FirestoreManager()

        UserDefaults.standard.set(signinUserName, forKey: "name")
        firestoreManager.setUserName(userIdentifier: userIdentifier, userName: signinUserName)
        
        let pokeToolCustomizingViewController = PokeToolCustomizingViewController()
        self.navigationController?.pushViewController(pokeToolCustomizingViewController, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        Messaging.messaging().delegate = self
        userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") as String? ?? ""
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                self.firestoreManager.setNotificationToken(userIdentifier: self.userIdentifier, notificationToken: token)
            }
        }
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
        nameTextField.setUnderLine(lineColor: .lightGray)
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

extension NameSettingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isNameEmpty = nameTextField.text == ""
        nextButton.isEnabled = !isNameEmpty
    }
}

extension NameSettingViewController: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

}
