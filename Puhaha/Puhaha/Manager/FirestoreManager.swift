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
        
        self.families = [Family(user: User(accountId: "",
                                           name: "모두",
                                           toolImage: UIImage(named: "IconEveryoneFilter")!,
                                           toolType: "",
                                           toolColor: "",
                                           familyCode: "",
                                           pokeState: Poke()),
                                isSelected: true)]
        
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
                
                let uploadUserEmail = data["uploadUser"] as? String ?? ""
                let uploadedTime = data["uploadTime"] as? String ?? ""
                let uploadedDate = data["uploadDate"] as? String ?? ""
                let reactionsValue = data["reactions"] as? [[String: String]] ?? []
                var reactions: [Reaction?] = [nil]
                for i in 0..<reactionsValue.count {
                    for key in reactionsValue[i].keys {
                        reactions.append(Reaction(reactionEmojiString: reactionsValue[i][key]!, reactedUserName: key))
                    }
                }
                
                let meal = Meal(mealImage: UIImage(), mealImageName: mealImageIndex, uploadUser: "", uploadUserEmail: uploadUserEmail, userIcon: UIImage(), tags: tags, uploadedDate: uploadedDate, uploadedTime: uploadedTime, reactions: reactions)
                
                DispatchQueue.main.async {
                    completion()
                }
                
                return meal
            }
        }
    }
    
    func getUploadUser(userEmail: String, completion: @escaping () -> Void) {
        user = User(accountId: userEmail)
        
        db.collection("Users").document(userEmail).addSnapshotListener { [self] (document, error) in
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
    
    func getSignInUser(userEmail: String, completion: @escaping () -> Void) {
        loginedUser = User(accountId: userEmail)
        
        db.collection("Users").document(userEmail).addSnapshotListener { [self] (document, error) in
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
                let userEmails: [String] = document.data()?["users"] as? [String] ?? []
                memberEmails = userEmails
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
                            let loginForm = data["loginForm"] as? Int ?? 0
                            
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
    
    func setPokingToolData(userEmail: String, tool passedTool: PokeTool) {
        
        let tool = passedTool.tool.imageFileName
        let color = convertUIColorToString(color: passedTool.color)
        
        db.collection("Users").document(userEmail).updateData([
            "pokingTool.tool": tool,
            "pokingTool.color": color
        ])
    }
    
    func addReaction(familyCode: String, meal: Meal, newReaction: [String: String]) {
        db.collection("Families").document(familyCode).collection("Meals").whereField("uploadUser", isEqualTo: meal.uploadUserEmail).whereField("uploadDate", isEqualTo: meal.uploadedDate).whereField("uploadTime", isEqualTo: meal.uploadedTime).getDocuments { querySnapshot, error in
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
    
    func setFamilyCode(userEmail: String, code: String) {
        db.collection("Users").document(userEmail).updateData(["familyCode": code])
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
    
    func setUpMeals(image: UIImage,
                    userEmail: String,
                    familyCode: String,
                    tags: [String]) {
        let today = Date.now
        
        let documentRef = db.collection("Families").document(familyCode).collection("Meals")
        let storageManager = StorageManager()
        let imageName: String = "img_\(today.dateText)_\(today.timeNumberText)\(today.secondsText()).jpeg"
        
        storageManager.uploadMealImage(image: image, familyCode: familyCode, imageName: imageName) {
            documentRef.addDocument(data: [
                "mealImageIndex": imageName,
                "uploadUser": userEmail,
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
    
    func addFamily(roomCode: String, userEmail: String) {
        db.collection("Families").document(roomCode).setData(["users": [userEmail]])
    }

    func addFamilyMember(roomCode: String, userEmail: String) {
            db.collection("Families").document(roomCode).getDocument { document, _ in
                let data = document?.data()
                var users: [String] = data?["users"] as? [String] ?? []
                users.append(userEmail)
                self.db.collection("Families").document(roomCode).updateData(["users": users])
            }
        }
    }
