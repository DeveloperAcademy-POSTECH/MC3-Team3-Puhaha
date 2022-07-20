//
//  SignInViewController.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/18.
//

import UIKit
import Firebase
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class SignInViewController: UIViewController {
    
    private var currentNonce: String?
    
    private let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "밥 먹언?"
      label.textColor = .black
      label.font = .systemFont(ofSize: 40, weight: .ultraLight)
      return label
    }()
    
    private let guidingTextLabel: UILabel = {
       let label = UILabel()
        label.text = "간편하게 로그인하고 다양한 서비스를 이용해보세요"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let emailLoginButton: CustomedLoginButton = {
        let button = CustomedLoginButton()
        button.setImage(UIImage(systemName: "envelope"), for: .normal)
        button.tintColor = UIColor.black
        button.setTitle("이메일로 가입하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        return button
    }()
    
    private let appleLoginButton: CustomedLoginButton = {
        let button = CustomedLoginButton()
        button.setImage(UIImage(systemName: "applelogo")?.withTintColor(.black), for: .normal)
        button.tintColor = UIColor.black
        button.setTitle("애플로 가입하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        
        button.addTarget(self,
                         action: #selector(appleLoginButtonTapped),
                         for: .touchUpInside)
                         // 눌렸을 때 함수를 인식하도록
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow

        [titleLabel, guidingTextLabel, emailLoginButton, appleLoginButton].forEach {
            view.addSubview($0)
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        guidingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLoginButton.translatesAutoresizingMaskIntoConstraints = false
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        
        guidingTextLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        guidingTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guidingTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        
        emailLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLoginButton.topAnchor.constraint(equalTo: guidingTextLabel.bottomAnchor, constant: 100).isActive = true
        
        appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleLoginButton.topAnchor.constraint(equalTo: emailLoginButton.bottomAnchor, constant: 22).isActive = true
    }
}

extension SignInViewController {
    @objc func appleLoginButtonTapped() {
        startSignInWithAppleFlow()
    }
}

// Apple Login 관련 코드
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // ASAuthorizationController (as = AuthenticationServices 약자)
        // ASAuthorizationController를 통해 애플에 요청 -> appleIDToken, idTokenString 받아 -> credential
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // nonce : 암호화 된 임의의 난수, 단 한번만 사용 가능한 값, 암호화 통신에 보통 사용
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error Apple sign in: %@", error)
                    return
                }
            }
        }
    }
}

extension SignInViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString() // 이 request에 nonce가 포함되어 릴레이 공격 방지, 암호화
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

extension SignInViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
