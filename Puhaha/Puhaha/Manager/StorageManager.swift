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
    let firestoreManager = FirestoreManager()
    var mealImage: UIImage!
    
    func getMealImage(familyCode: String, date: String, imageName: String, completion: @escaping () -> Void) {
        let mealRef = storageRef.child(familyCode).child(date)
        mealRef.child("\(imageName).jpeg").getData(maxSize: 1 * 3_840 * 2_160) { [self] (data, error) in
            if let error = error {
                print(error)
                mealImage = UIImage()
            } else {
                mealImage = UIImage(data: data!)!
                completion()
            }
        }
    }
    
    func uploadMealImage(image: UIImage, familyCode: String) {
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8) ?? Data()
        let filePathDate = Date().dateText
        let filePathUser = familyCode
        let fileMealImageIndex = String(firestoreManager.meals.count)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.child(filePathUser).child(filePathDate).child("\(fileMealImageIndex).jpeg").putData(data, metadata: metaData) { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("image uploaded")
            }
        }
    }
}
