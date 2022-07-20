//
//  Meal.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import Foundation
import UIKit

struct Meal {
    let mealImage: UIImage
    let userName: String
    let userIcon: UIImage
    let tag: [Tag]
}

#if DEBUG
extension Meal {
    static var sampleMeals: [Meal] = [
        Meal(mealImage: UIImage(named: "MealImage1")!, userName: "콜리", userIcon: UIImage(named: "Spoon")!, tag: Tag.sampleTag),
        Meal(mealImage: UIImage(named: "MealImage2")!, userName: "키", userIcon: UIImage(named: "Spoon")!, tag: Tag.sampleTag),
        Meal(mealImage: UIImage(named: "MealImage3")!, userName: "레나", userIcon: UIImage(named: "Spoon")!, tag: Tag.sampleTag),
        Meal(mealImage: UIImage(named: "MealImage4")!, userName: "티모", userIcon: UIImage(named: "Spoon")!, tag: Tag.sampleTag),
        Meal(mealImage: UIImage(named: "MealImage5")!, userName: "우기", userIcon: UIImage(named: "Spoon")!, tag: Tag.sampleTag)
    ]
}
#endif
