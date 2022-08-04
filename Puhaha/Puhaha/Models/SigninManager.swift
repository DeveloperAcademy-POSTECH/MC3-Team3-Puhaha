//
//  SigninManager.swift
//  Puhaha
//
//  Created by 김소현 on 2022/08/03.
//

import UIKit
import FirebaseFirestore

class SigninManager: ObservableObject {
    private var db = Firestore.firestore()
    private let userDefaultsEmail = UserDefaults.standard.string(forKey: "loginedUserEmail") as String? ?? "defaultsEmail"
    
    @Published var loginedUser: Users
    
    init() {
        self.loginedUser = Users(accountId: userDefaultsEmail)
    }
    
    func getSignInUser(userEmail: String, completion: @escaping () -> Void) {
        loginedUser = Users(accountId: userEmail)
        
        db.collection("Users").document(userEmail).getDocument(source: .default) { [self] (document, error) in
            if let document = document {
                let name = document.data()?["name"] as? String ?? ""
                let familyCode = document.data()?["familyCode"] as? String ?? ""
                let pokingTool = document.data()?["pokingTool"] as? [String: String] ?? [:]
                let pokeStateValue = document.data()?["pokeState"] as? [String: String] ?? [:]

                let pokingToolColor: String = pokingTool["color"] ?? ""
                let pokingToolTool: String = pokingTool["tool"] ?? ""
                let toolImage: UIImage = UIImage(named: "\(pokingToolColor)_\(pokingToolTool)") ?? UIImage()
                let pokedBy: String = pokeStateValue["pokedBy"] ?? ""
                let pokedTime: String = pokeStateValue["pokedTime"] ?? ""
                
                loginedUser.setName(name: name)
                loginedUser.setToolImage(toolImage: toolImage)
                loginedUser.setFamilyCode(code: familyCode)
                loginedUser.setPoke(poke: Poke(pokedBy: pokedBy, pokedTime: pokedTime))
                completion()
            } else {
                print(error ?? "")
            }
        }
    }
}
