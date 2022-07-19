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
        Meal(mealImage: UIImage(named: "MealImage1")!, userName: "Colli", userIcon: UIImage(named: "Spoon")!, tag: []),
        Meal(mealImage: UIImage(named: "MealImage2")!, userName: "Key", userIcon: UIImage(named: "Spoon")!, tag: []),
        Meal(mealImage: UIImage(named: "MealImage3")!, userName: "Lena", userIcon: UIImage(named: "Spoon")!, tag: []),
        Meal(mealImage: UIImage(named: "MealImage4")!, userName: "Teemo", userIcon: UIImage(named: "Spoon")!, tag: []),
        Meal(mealImage: UIImage(named: "MealImage5")!, userName: "Woogy", userIcon: UIImage(named: "Spoon")!, tag: [])
    ]
}
#endif
