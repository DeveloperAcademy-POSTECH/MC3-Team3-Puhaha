//
//  SingInViewController+Delegate.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/31.
//

import UIKit

import AuthenticationServices
import CryptoKit
import FirebaseAuth

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
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
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    print("Error Apple sign in: %@", error)
                    return
                }
            }
            
            let userIdentifier = appleIDCredential.user as String? ?? ""
            UserDefaults.standard.set(appleIDCredential.user, forKey: "forUserID")
            UserDefaults.standard.set(userIdentifier, forKey: "userIdentifier")

            let firestoreManager = FirestoreManager()
            firestoreManager.setDefaultUserData(userIdentifier: userIdentifier)
            // 얘는 왜 있을까? -> 로그인 과정이 끝나면, 해당 정보로 서버 상에서 유저를 생성한다.
            
            var user = User()
            var destinationViewController: UIViewController = UIViewController()
            
            firestoreManager.getSignInUser(userIdentifier: userIdentifier, completion: {
                user = firestoreManager.loginedUser
            })
            
            let name = user.getName()
            let familyCode = user.getFamilyCode()
            
            if name == "" {
                destinationViewController = NameSettingViewController()
            } else if familyCode == "" {
                destinationViewController = CreateFamilyViewController()
            } else {
                destinationViewController = MainTabViewController()
            }
            
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
}

extension SignInViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
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
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
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

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
