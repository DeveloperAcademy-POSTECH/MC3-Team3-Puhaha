//
//  FirestoreManager.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/31.
//

import UIKit

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject {
    private let tagColor: [UIColor] = [.customPurple, .customBlue, .customGreen]
    
    private var db = Firestore.firestore()
    
    @Published var meals: [Meal]
    @Published var user: User
    @Published var loginedUser: User
    @Published var memberEmails: [String]
    @Published var families: [Family]
    @Published var documentsCount = 0
    
    init() {
        self.meals = []
        self.user = User()
        self.loginedUser = User()
        self.memberEmails = []
        self.families = [Family(user: User(accountId: "", name: "모두", loginForm: 0, toolImage: UIImage(named: "IconEveryoneFilter")!, familyCode: "", pokeState: Poke()), isSelected: true)]
    }
    
    func fetchMeals(familyCode: String, date: Date, completion: @escaping () -> Void) {
        db.collection("Families").document(familyCode).collection("Meals").whereField("uploadedDate", isEqualTo: date.dateText).addSnapshotListener { [self] (querySnapshot, _) in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            meals = documents.map { (queryDocumentSnapshot) -> Meal in
                let data = queryDocumentSnapshot.data()
                
                let mealImageIndex = data["mealImageIndex"] as? String ?? ""
                let tagsString = data["tags"] as? [String ] ?? []
                var tags: [Tag] = []
                for i in 0..<tagsString.count {
                    tags.append(Tag(content: tagsString[i], backgroundColor: self.tagColor[i]))
                }
                let uploadUserEmail = data["uploadUser"] as? String ?? ""
                let uploadedTime = data["uploadedTime"] as? String ?? ""
                let uploadedDate = data["uploadedDate"] as? String ?? ""
                let reactionsValue = data["reactions"] as? [[String: String]] ?? []
                var reactions: [Reaction?] = [nil]
                for i in 0..<reactionsValue.count {
                    for key in reactionsValue[i].keys {
                        reactions.append(Reaction(reactionEmojiString: reactionsValue[i][key]!, reactedUserName: key))
                    }
                }
                
                let meal = Meal(mealImage: UIImage(), mealImageName: mealImageIndex, uploadUser: uploadUserEmail, userIcon: UIImage(), tags: tags, uploadedDate: uploadedDate, uploadedTime: uploadedTime, reactions: reactions)
                
                DispatchQueue.main.async {
                    completion()
                }
                
                return meal
            }
        }
    }
    
    func getUploadUser(userEmail: String, completion: @escaping () -> Void) {
        user = User(accountId: userEmail)
        
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
                
                user.setName(name: name)
                user.setToolImage(toolImage: toolImage)
                user.setFamilyCode(code: familyCode)
                user.setPoke(poke: Poke(pokedBy: pokedBy, pokedTime: pokedTime))
                
                completion()
            } else {
                print(error ?? "")
            }
        }
    }
    
    func getSignInUser(userEmail: String, completion: @escaping () -> Void) {
        loginedUser = User(accountId: userEmail)
        
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
    
    func getFamilyMember(familyCode: String, completion: @escaping () -> Void) {
        db.collection("Families").document(familyCode).getDocument(source: .default) { [self] (document, error) in
            if let document = document {
                let userEmails: [String] = document.data()?["users"] as? [String] ?? []
                memberEmails = userEmails
                
                db.collection("Users").whereField("familyCode", isEqualTo: familyCode).getDocuments(source: .default) { [self] (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            
                            let accountId = data["accountId"] as? String ?? ""
                            let name = data["name"] as? String ?? ""
                            let loginForm = data["loginForm"] as? Int ?? 0

                            let familyCode = data["familyCode"] as? String ?? ""
                            let pokingTool = data["pokingTool"] as? [String: String] ?? [:]
                            let pokeStateValue = data["pokeState"] as? [String: String] ?? [:]

                            let pokingToolColor: String = pokingTool["color"] ?? ""
                            let pokingToolTool: String = pokingTool["tool"] ?? ""
                            let toolImage: UIImage = UIImage(named: "\(pokingToolColor)_\(pokingToolTool)") ?? UIImage()
                            let pokedBy: String = pokeStateValue["pokedBy"] ?? ""
                            let pokedTime: String = pokeStateValue["pokedTime"] ?? ""
                            
                            let user = User(accountId: accountId, name: name, loginForm: loginForm, toolImage: toolImage, familyCode: familyCode, pokeState: Poke(pokedBy: pokedBy, pokedTime: pokedTime))
                            
                            families.append(Family(user: user, isSelected: false))
                        }
                    }
                    completion()
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    func setFamilyCode(userEmail: String, code: String) {
        db.collection("Users").document(userEmail).setData(["familyCode": code])
    }
    
    func setUserName(userEmail: String, userName: String) {
        db.collection("Users").document(userEmail).updateData(["name": userName])
    }
    
    func setDefaultUserData(userEmail: String) {
        db.collection("Users").document(userEmail).setData(["familyCode": "",
                                                                  "name": "",
                                                                  "pokeState": ["pokedBy": "",
                                                                                "pokedtime": ""],
                                                                  "pokingTool": ["color": "",
                                                                                 "tool": ""]])
    }
    
    func setUpMeals(userEmail: String,
                    familyCode: String,
                    timeTag: String,
                    menuTag: String,
                    emotionTag: String,
                    completion: @escaping () -> Void) {
        
        var documentRef: DocumentReference
        var count = 0
        
        documentsCount = { [self] in
            db.collection("Families").document(familyCode).collection("Meals").getDocuments() { [self] querySnapShot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapShot!.documents {
                        count += 1
                        print("\(document.documentID) => \(document.data())")
                    }
                    print("Count: \(count)")
                    count += 1
                    
                }
                print("collection안에서: \(count)")
                self.documentsCount = count
            }
            print("return 전: \(count)")
            return self.documentsCount
        }()
        
        documentRef = db.collection("Families").document(familyCode).collection("Meals").addDocument(data: [
            "mealImageIndex": String(documentsCount),
            "uploadUser": userEmail,
            "uploadDate": Date().dateText,
            "uploadTime": Date().timeNumberText,
            "tags": ["0": timeTag,
                     "1": menuTag,
                     "2": emotionTag]
        ])

        print("documents 끝나고 documentsCount, count: \(documentsCount), \(count)")    }
}
