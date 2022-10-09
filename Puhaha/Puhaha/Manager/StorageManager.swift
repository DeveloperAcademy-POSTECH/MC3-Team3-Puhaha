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
                mealImage = UIImage(data: data!)!
            }
            completion()
        }
    }
    
    func uploadMealImage(image: UIImage, familyCode: String, imageName: String, completion: @escaping () -> Void) {

        // MARK: - 사진 사이즈 조정 코드
//        let size: CGFloat = 200
//
//        let renderedImage = image.imageRendering(size: CGSize(width: size, height: image.size.height / image.size.width * size))
//        let data = renderedImage.jpegData(compressionQuality: 0) ?? Data()
        // MARK: 사진 사이즈 조정 코드 끝 -
        
        let data = image.jpegData(compressionQuality: 0) ?? Data()
        
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
                    completion()
                }
            }
        }

    }
    
    func deleteMealImage(familyCode: String, mealImageIndex: String) {
        
        let fileLocation = "Families/\(familyCode)/Meals/\(mealImageIndex)"
        
        storageRef.child(fileLocation).delete {
            error in
            if let error = error {
                print(error)
            } else {
                print("deleted successfully")
            }
        }
    }
}
