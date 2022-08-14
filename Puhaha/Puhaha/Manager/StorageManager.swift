//
//  StorageManager.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/31.
//

import UIKit

import FirebaseStorage

class StorageManager {
    let storageRef = Storage.storage().reference()
    var mealImage: UIImage!
    
    func getMealImage(familyCode: String, date: String, imageName: String, completion: @escaping () -> Void) {
        let mealRef = storageRef.child(familyCode).child(date)
        mealRef.child(imageName).getData(maxSize: 1 * 3_840 * 2_160) { [self] (data, error) in
            if let error = error {
                print(error)
                mealImage = UIImage()
            } else {
                mealImage = UIImage(data: data!)!
                completion()
            }
        }
    }
}
