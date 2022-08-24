//
//  AppDelegate.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/14.
//

import UIKit

import FirebaseCore
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let userDefaultsRoomCode = UserDefaults.standard.string(forKey: "roomCode") as String? ?? ""
    private let userDefaultsName = UserDefaults.standard.string(forKey: "name") as String? ?? ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let forUserID = UserDefaults.standard.string(forKey: "forUserID")
        appleIDProvider.getCredentialState(forUserID: forUserID ?? "") { (credentialState, _) in
            switch credentialState {
            case .authorized:
                DispatchQueue.main.async {
                    print(UserDefaults.standard.string(forKey: "userIdentifier")!)
//                    let mainTabViewController = MainTabViewController()
//                    self.window?.rootViewController = mainTabViewController
                    print("authorized")
                    // The Apple ID credential is valid.
                }
            case .revoked:
                DispatchQueue.main.async {
                    print("revoked")
//                    let signInViewController = SignInViewController()
//                    self.window?.rootViewController = signInViewController
                }
                    
            case .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                print("notFound")
                DispatchQueue.main.async {
//                    let signInViewController = SignInViewController()
//                    self.window?.rootViewController = signInViewController
                    // self.window?.rootViewController?.showLoginViewController()
                }
            default:
                break
                
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

}

