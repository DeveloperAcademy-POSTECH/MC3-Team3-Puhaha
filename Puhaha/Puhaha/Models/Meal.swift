//
//  Meal.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import UIKit

struct Meal {
    var mealImage: UIImage
    let mealImageName: String
    var uploadUser: String
    var userIcon: UIImage
    let tags: [Tag]
    let uploadedDate: String
    let uploadedTime: String
    var reactions: [Reaction?]
    
    init(mealImage: UIImage, mealImageName: String, uploadUser: String, userIcon: UIImage, tags: [Tag], uploadedDate: String, uploadedTime: String, reactions: [Reaction?]) {
        self.mealImage = mealImage
        self.mealImageName = mealImageName
        self.uploadUser = uploadUser
        self.userIcon = userIcon
        self.tags = tags
        self.uploadedDate = uploadedDate
        self.uploadedTime = uploadedTime
        self.reactions = reactions
    }
}
