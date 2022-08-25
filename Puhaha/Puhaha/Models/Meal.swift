//
//  Meal.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import UIKit

class Meal: ObservableObject {
    var mealImage: UIImage
    let mealImageName: String
    var uploadUser: String
    var userIdentifier: String
    var userIcon: UIImage
    var tags: [Tag]
    let uploadedDate: String
    let uploadedTime: String
    @Published var reactions: [Reaction?]
    
    init(mealImage: UIImage, mealImageName: String, uploadUser: String, userIdentifier: String, userIcon: UIImage, tags: [Tag], uploadedDate: String, uploadedTime: String, reactions: [Reaction?]) {
        self.mealImage = mealImage
        self.mealImageName = mealImageName
        self.uploadUser = uploadUser
        self.userIdentifier = userIdentifier
        self.userIcon = userIcon
        self.tags = tags
        self.uploadedDate = uploadedDate
        self.uploadedTime = uploadedTime
        self.reactions = reactions
    }
}
