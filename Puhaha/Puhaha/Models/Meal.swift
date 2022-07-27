//
//  Meal.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import UIKit

struct Meal {
    let mealImage: UIImage
    let uploadUser: String
    let userIcon: UIImage
    let tags: [Tag]
    let uploadedTime: Date
}

#if DEBUG
extension Meal {
    static var sampleMeals: [Meal] = [
        Meal(mealImage: UIImage(named: "MealImage1")!, uploadUser: "콜리", userIcon: UIImage(named: "Spoon")!, tags: Tag.sampleTag, uploadedTime: Date()),
        Meal(mealImage: UIImage(named: "MealImage2")!, uploadUser: "키", userIcon: UIImage(named: "Spoon")!, tags: Tag.sampleTag, uploadedTime: Date()),
        Meal(mealImage: UIImage(named: "MealImage3")!, uploadUser: "레나", userIcon: UIImage(named: "Spoon")!, tags: Tag.sampleTag, uploadedTime: Date()),
        Meal(mealImage: UIImage(named: "MealImage4")!, uploadUser: "티모", userIcon: UIImage(named: "Spoon")!, tags: Tag.sampleTag, uploadedTime: Date()),
        Meal(mealImage: UIImage(named: "MealImage5")!, uploadUser: "우기", userIcon: UIImage(named: "Spoon")!, tags: Tag.sampleTag, uploadedTime: Date())
    ]
}
#endif
