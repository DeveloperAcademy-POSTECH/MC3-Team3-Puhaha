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
    @Published var userIdentifiers: [String]
    @Published var families: [Family]
    @Published var documentsCount = 0
    @Published var isExistFamily: Bool
    
    init() {
        self.meals = []
        self.user = User()
        self.loginedUser = User()
        self.userIdentifiers = []
        
        self.families = [Family(user: User(accountId: "",
                                           name: "모두",
                                           toolImage: UIImage(named: "IconEveryoneFilter")!,
                                           toolType: "",
                                           toolColor: "",
                                           familyCode: "",
                                           pokeState: Poke()),
                                isSelected: true)]
        
        self.isExistFamily = false
    }
    
    func fetchMeals(familyCode: String, date: Date?, completion: @escaping () -> Void) {
        var documentPath: Query = db.collection("Families").document(familyCode).collection("Meals")
        
        if date != nil {
            documentPath = documentPath.whereField("uploadDate", isEqualTo: date!.dateText)
        }
        
        documentPath.order(by: "uploadTime", descending: true).addSnapshotListener { [self] (querySnapshot, _) in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            meals = documents.map { (queryDocumentSnapshot) -> Meal in
                let data = queryDocumentSnapshot.data()
                
                let mealImageIndex = data["mealImageIndex"] as? String ?? ""
                let tagsString = data["tags"] as? [String: String] ?? [:]
                var tags: [Tag] = []
                for key in tagsString.keys {
                    tags.append(Tag(content: tagsString[key] ?? "", backgroundColor: self.tagColor[Int(key) ?? 0]))
                }
                
                let userIdentifier = data["uploadUser"] as? String ?? ""
                let uploadedTime = data["uploadTime"] as? String ?? ""
                let uploadedDate = data["uploadDate"] as? String ?? ""
                let reactionsValue = data["reactions"] as? [[String: String]] ?? []
                var reactions: [Reaction?] = [nil]
                for i in 0..<reactionsValue.count {
                    for key in reactionsValue[i].keys {
                        reactions.append(Reaction(reactionEmojiString: reactionsValue[i][key]!, reactedUserName: key))
                    }
                }
                
                let meal = Meal(mealImage: UIImage(), mealImageName: mealImageIndex, uploadUser: "", userIdentifier: userIdentifier, userIcon: UIImage(), tags: tags, uploadedDate: uploadedDate, uploadedTime: uploadedTime, reactions: reactions)
                
                DispatchQueue.main.async {
                    completion()
                }
                
                return meal
            }
        }
    }
    
    func getUploadUser(userIdentifier: String, completion: @escaping () -> Void) {
        user = User(accountId: userIdentifier)
        
        db.collection("Users").document(userIdentifier).addSnapshotListener { [self] (document, error) in
            if let document = document {
                let name = document.data()?["name"] as? String ?? ""
                let familyCode = document.data()?["familyCode"] as? String ?? ""
                let pokingTool = document.data()?["pokingTool"] as? [String: String] ?? [:]
                let pokeStateValue = document.data()?["pokeState"] as? [String: String] ?? [:]
                
                let pokingToolColor: String = pokingTool["color"]?.lowercased() ?? ""
                let pokingToolTool: String = pokingTool["tool"]?.lowercased() ?? ""
                let toolImage: UIImage = UIImage(named: "\(pokingToolColor.lowercased())_\(pokingToolTool)") ?? UIImage()
                
                /* Tool enum 사용할 경우
                 let toolType = convertStringToToolType(string: pokingTool["tool"] ?? "")
                 let toolColor = convertStringToToolColor(string: pokingTool["color"] ?? "")
                 let toolImage: UIImage = UIImage(named: "\(toolColor)_\(toolType.imageFileName)") ?? UIImage()
                 */
                
                let pokedBy: String = pokeStateValue["pokedBy"] ?? ""
                let pokedTime: String = pokeStateValue["pokedTime"] ?? ""
                
                user.setName(name: name)
                user.setToolImage(toolImage: toolImage)
                user.setToolType(with: pokingToolTool)
                user.setToolColor(with: pokingToolColor)
                user.setFamilyCode(code: familyCode)
                user.setPoke(poke: Poke(pokedBy: pokedBy, pokedTime: pokedTime))
                completion()
            } else {
                print(error ?? "")
            }
        }
    }
    
    func getSignInUser(userIdentifier: String, completion: @escaping () -> Void) {
        loginedUser = User(accountId: userIdentifier)
        
        db.collection("Users").document(userIdentifier).addSnapshotListener { [self] (document, error) in
            if let document = document {
                let name = document.data()?["name"] as? String ?? ""
                let familyCode = document.data()?["familyCode"] as? String ?? ""
                let pokingTool = document.data()?["pokingTool"] as? [String: String] ?? [:]
                let pokeStateValue = document.data()?["pokeState"] as? [String: String] ?? [:]
                
                let pokingToolColor: String = pokingTool["color"]?.lowercased() ?? ""
                let pokingToolType: String = pokingTool["tool"]?.lowercased() ?? ""
                let toolImage: UIImage = UIImage(named: "\(pokingToolColor)_\(pokingToolType)") ?? UIImage()
                let pokedBy: String = pokeStateValue["pokedBy"] ?? ""
                let pokedTime: String = pokeStateValue["pokedTime"] ?? ""
                
                loginedUser.setName(name: name)
                loginedUser.setToolImage(toolImage: toolImage)
                loginedUser.setToolType(with: pokingToolType)
                loginedUser.setToolColor(with: pokingToolColor)
                loginedUser.setFamilyCode(code: familyCode)
                loginedUser.setPoke(poke: Poke(pokedBy: pokedBy, pokedTime: pokedTime))
                
                completion()
                
            } else {
                print(error ?? "")
            }
        }
    }
    
    func getFamilyMember(familyCode: String, completion: @escaping () -> Void) {
        db.collection("Families").document(familyCode).addSnapshotListener { [self] (document, error) in
            if let document = document {
                let userIdentifier: [String] = document.data()?["users"] as? [String] ?? []
                userIdentifiers = userIdentifier
                db.collection("Users").whereField("familyCode", isEqualTo: familyCode).addSnapshotListener { [self] (querySnapshot, _) in/*.getDocuments(source: .default) { [self] (querySnapshot, error) in*/
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        families = [Family(user: User(accountId: "",
                                                      name: "모두",
                                                      toolImage: UIImage(named: "IconEveryoneFilter")!,
                                                      toolType: "",
                                                      toolColor: "",
                                                      familyCode: "",
                                                      pokeState: Poke()),
                                           isSelected: true)]
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            
                            let accountId = data["accountId"] as? String ?? ""
                            let name = data["name"] as? String ?? ""
                            /* 안드로이드 개발이 되는 경우 0: 애플 계정 로그인, 1: 구글 계정 로그인으로 사용 예정
                             let loginForm = data["loginForm"] as? Int ?? 0
                             */
                            let familyCode = data["familyCode"] as? String ?? ""
                            let pokingTool = data["pokingTool"] as? [String: String] ?? [:]
                            let pokeStateValue = data["pokeState"] as? [String: String] ?? [:]
                            
                            let pokingToolColor: String = pokingTool["color"]?.lowercased() ?? ""
                            let pokingToolTool: String = pokingTool["tool"]?.lowercased() ?? ""
                            let toolImage: UIImage = UIImage(named: "\(pokingToolColor)_\(pokingToolTool)") ?? UIImage()
                            let pokedBy: String = pokeStateValue["pokedBy"] ?? ""
                            let pokedTime: String = pokeStateValue["pokedTime"] ?? ""
                            
                            let user = User(accountId: accountId,
                                            name: name,
                                            toolImage: toolImage,
                                            toolType: pokingToolTool,
                                            toolColor: pokingToolColor,
                                            familyCode: familyCode,
                                            pokeState: Poke(pokedBy: pokedBy, pokedTime: pokedTime))
                            
                            families.append(Family(user: user, isSelected: false))
                        }
                        completion()
                    }
                }
            } else {
                print(error ?? "")
            }
        }
    }
    
    func setPokingToolData(userIdentifier: String, tool passedTool: PokeTool) {
        
        let tool = passedTool.tool.imageFileName
        let color = convertUIColorToString(color: passedTool.color)
        
        db.collection("Users").document(userIdentifier).updateData([
            "pokingTool.tool": tool,
            "pokingTool.color": color
        ])
    }
    
    func addReaction(familyCode: String, meal: Meal, newReaction: [String: String]) {
        db.collection("Families").document(familyCode).collection("Meals").whereField("uploadUser", isEqualTo: meal.userIdentifier).whereField("uploadDate", isEqualTo: meal.uploadedDate).whereField("uploadTime", isEqualTo: meal.uploadedTime).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    var reactions = data["reactions"] as? [[String: String]] ?? []
                    reactions.append(newReaction)
                    document.reference.updateData(["reactions": reactions])
                }
            }
        }
    }
    
    func setFamilyCode(userIdentifier: String, code: String) {
        db.collection("Users").document(userIdentifier).updateData(["familyCode": code])
    }
    
    func deleteFamilyCode(userIdentifier: String) {
        db.collection("Users").document(userIdentifier).updateData(["familyCode": ""])
    }
    
    func setUserName(userIdentifier: String, userName: String) {
        db.collection("Users").document(userIdentifier).updateData(["name": userName])
    }
    
    func setDefaultUserData(userIdentifier: String) {
        db.collection("Users").document(userIdentifier).setData(["familyCode": "",
                                                                 "name": "",
                                                                 "pokeState": ["pokedBy": "",
                                                                               "pokedtime": ""],
                                                                 "pokingTool": ["color": "",
                                                                                "tool": ""]])
    }
    
    func isExistFamily(roomCode: String, completion: @escaping () -> Void) {
        db.collection("Families").document(roomCode).getDocument { document, error in
            let isExist = document?.exists ?? false
            self.isExistFamily = isExist
            completion()
        }
    }
    
    func setUpMeals(image: UIImage,
                    userIdentifier: String,
                    familyCode: String,
                    tags: [String]) {
        let today = Date.now
        
        let documentRef = db.collection("Families").document(familyCode).collection("Meals")
        let storageManager = StorageManager()
        let imageName: String = "img_\(today.dateText)_\(today.timeNumberText)\(today.secondsText()).jpeg"
        
        storageManager.uploadMealImage(image: image, familyCode: familyCode, imageName: imageName) {
            documentRef.addDocument(data: [
                "mealImageIndex": imageName,
                "uploadUser": userIdentifier,
                "uploadDate": Date().dateText,
                "uploadTime": Date().timeNumberText,
                "tags": ["0": tags[0],
                         "1": tags[1],
                         "2": tags[2]
                        ],
                "reactions": []])
        }
        print("이미지이름: \(imageName)")
    }
    
    func addFamily(roomCode: String, userIdentifier: String) {
        db.collection("Families").document(roomCode).setData(["users": [userIdentifier]])
    }
    
    func addFamilyMember(roomCode: String, userIdentifier: String) {
        db.collection("Families").document(roomCode).getDocument { document, _ in
            let data = document?.data()
            var users: [String] = data?["users"] as? [String] ?? []
            users.append(userIdentifier)
            self.db.collection("Families").document(roomCode).updateData(["users": users])
        }
    }
    
    func deleteAccount(roomCode: String, userIdentifier: String) {
        db.collection("Families").document(roomCode).collection("Meals").whereField("uploadUser", isEqualTo: userIdentifier).getDocuments { snapshot, error in
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    
                    document.reference.delete()
                }
            }
        }
        db.collection("Users").document(userIdentifier).delete()
        print("successfully deleted")
        
        
        db.collection("Families").document(roomCode).getDocument { document, _ in
            
            let data = document?.data()
            let users: [String] = data?["users"] as? [String] ?? []
            var newUsers: [String] = []

            for user in users where user != userIdentifier {
                newUsers.append(user)
            }
            
            self.db.collection("Families").document(roomCode).updateData(["users": newUsers])
        }
    }
}
