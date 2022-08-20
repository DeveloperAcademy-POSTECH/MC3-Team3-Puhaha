//
//  SceneDelegate.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var viewController: UIViewController!
    private let userDefaultsRoomCode = UserDefaults.standard.string(forKey: "roomCode") as String? ?? "-"
    private let userDefaultsName = UserDefaults.standard.string(forKey: "name") as String? ?? "-"
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
//        UserDefaults.standard.set("", forKey: "name")
//        UserDefaults.standard.set("", forKey: "roomCode")
//        UserDefaults.standard.set("", forKey: "loginedUserEmail")
//        UserDefaults.standard.set("", forKey: "forUserID")
        
        window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
        
        if userDefaultsName == "" && userDefaultsRoomCode != "" {
            window?.rootViewController?.navigationController?.pushViewController(NameSettingViewController(), animated: true)
        } else if userDefaultsName != "" && userDefaultsRoomCode != "" {
            window?.rootViewController?.navigationController?.pushViewController(MainTabViewController(), animated: true)
        }
        
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
