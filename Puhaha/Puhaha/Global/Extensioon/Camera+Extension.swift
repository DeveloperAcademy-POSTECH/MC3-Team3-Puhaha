//
//  Camera+Extension.swift
//  Puhaha
//
//  Created by Lena on 2022/08/01.
//

import UIKit
import PhotosUI

/// 사진 라이브러리에서 선택을 끝냈을 때
extension MainTabViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else { return print("selected Image error")}
                    
                    let uploadViewController = UploadViewController()
                    
                    uploadViewController.pictureImageView.image = selectedImage
                    uploadViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                                        title: "취소",
                                        style: .plain,
                                        target: self,
                                        action: #selector(self.dismissSelf))
                    uploadViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
                                        title: "업로드",
                                        style: .done,
                                        target: self,
                                        action: #selector(self.dismissSelf))
                    
                    let navigationViewController = UINavigationController(rootViewController: uploadViewController)
                    
                    uploadViewController.navigationController?.navigationBar.backgroundColor = .white
                    navigationViewController.modalPresentationStyle = .fullScreen
                    self.present(navigationViewController, animated: true)
                }
            }
        }
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

/// 카메라에서 사진 촬영을 끝냈을 때
extension MainTabViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.dismiss(animated: true)
        
        let uploadViewController = UploadViewController()
        uploadViewController.pictureImageView.image = captureImage
        uploadViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                            title: "취소",
                            style: .plain,
                            target: self,
                            action: #selector(self.dismissSelf))
        uploadViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
                            title: "업로드",
                            style: .done,
                            target: self,
                            action: #selector(self.dismissSelf))
        
        let navigationViewController = UINavigationController(rootViewController: uploadViewController)
        
        uploadViewController.navigationController?.navigationBar.backgroundColor = .white
        navigationViewController.modalPresentationStyle = .fullScreen
        self.present(navigationViewController, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
