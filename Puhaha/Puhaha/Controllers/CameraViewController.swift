//
//  CameraViewController.swift
//  Puhaha
//
//  Created by Lena on 2022/07/18.
//

import UIKit

class CameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(cameraImageView)
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentCamera()
    }
    
    private var cameraImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func configureConstraints() {
        cameraImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cameraImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        cameraImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        cameraImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        cameraImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    /// 카메라 촬영화면을 모달로 띄우는 함수
    private func presentCamera() {
        let cameraPickerController = UIImagePickerController()
        cameraPickerController.sourceType = .camera
        cameraPickerController.allowsEditing = true
        cameraPickerController.delegate = self
        present(cameraPickerController, animated: true)
    }
}

extension CameraViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else {
            print("no image found")
            return
        }
        
        print(image.size)
    }
}
