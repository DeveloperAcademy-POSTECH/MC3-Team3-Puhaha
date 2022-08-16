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
    @Published var mealImage: UIImage!
    
    func getMealImage(familyCode: String, date: String, imageName: String, completion: @escaping () -> Void) {
        let mealRef = storageRef.child(familyCode).child(date)
        mealRef.child(imageName).getData(maxSize: 1 * 3_840 * 2_160) { [self] (data, error) in
            if let error = error {
                print(error)
                mealImage = UIImage()
            } else {
                mealImage = UIImage(data: data!)!/*.preparingThumbnail(of: CGSize(width: 100, height: 100))*/
                completion()
            }
        }
    }
    
//    func uploadMealImage(image: UIImage, familyCode: String, imageName: String) {
//        var data = Data()
//        data = image.jpegData(compressionQuality: 0.8) ?? Data()
//        let filePathDate = Date().dateText
//        let filePathUser = familyCode
//        let fileMealImageIndex = imageName
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpeg"
//
//        storageRef.child(filePathUser).child(filePathDate).child("\(fileMealImageIndex).jpeg").putData(data, metadata: metaData) { _, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            } else {
//                print("image uploaded")
//            }
//        }
//    }
    
    func uploadMealImage(image: UIImage, familyCode: String, imageName: String) {
        var data = Data()
        data = image.jpegData(compressionQuality: 0.05) ?? Data()
        let filePathDate = Date().dateText
        let filePathUser = familyCode
        let fileMealImageIndex = imageName
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        DispatchQueue.main.async {
            self.storageRef.child(filePathUser).child(filePathDate).child(fileMealImageIndex).putData(data, metadata: metaData) { _, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    print("image uploaded")
                }
            }
        }

    }
}
