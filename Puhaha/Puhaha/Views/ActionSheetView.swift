//
//  ActionSheetView.swift
//  Puhaha
//
//  Created by Lena on 2022/07/19.
//

import UIKit
import PhotosUI

class ActionSheetView: UIViewController {
    
    var itemProviders: [NSItemProvider] = []
    var iterator: IndexingIterator<[NSItemProvider]>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cameraButton)
        configureConstraints()
    }
    
    private var imageView: UIImageView = {
       let image = UIImageView()
        return image
    }()
    
    private var cameraButton: UIButton = {
        let button = UIButton()
        button.configuration?.image = UIImage(systemName: "camera")
        button.tintColor = .yellow
        button.layer.cornerRadius = 50
        button.layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(tapCameraButton(_ :)), for: .touchUpInside)
        
        return button
    }()
    
    @objc internal func tapCameraButton(_ sender: Any) {
        if let button = sender as? UIButton {
            let sheet = UIAlertController(title: "식사 업로드하기", message: nil, preferredStyle: .actionSheet)
            let takePhoto = UIAlertAction(title: "사진 촬영하기", style: .default) {
                (_: UIAlertAction) in
                self.presentCamera()
            }
            let chooseLibarary = UIAlertAction(title: "라이브러리에서 선택하기", style: .default) {
                (_: UIAlertAction) in
                self.selectPhotos()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            [takePhoto, chooseLibarary, cancel].forEach { sheet.addAction($0)}
            
            self.present(sheet, animated: true, completion: nil)
        }
    }
    
    /// 카메라 촬영화면을 모달로 띄우는 함수
    private func presentCamera() {
        let cameraPickerController = UIImagePickerController()
        cameraPickerController.sourceType = .camera
        cameraPickerController.allowsEditing = true
        present(cameraPickerController, animated: true)
    }
    
    /// 앨범에서 사진을 선택하는 함수
    private func selectPhotos() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    private func displayNextImage() {
        if let itemProvider = iterator?.next(), itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = imageView.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                if error == nil {
                    DispatchQueue.main.async {
                        guard let self = self, let image = image as? UIImage,
                                self.imageView.image == previousImage else { return }
                        self.imageView.image = image
                    }
                } else {
                    print("image load failed: \(String(describing: error))")
                }
            }
        }
    }
    
    private func configureConstraints() {
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cameraButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        cameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 50).isActive = true
    }
}

extension ActionSheetView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { _, _ in
                
                self.itemProviders = results.map(\.itemProvider)
                self.iterator = self.itemProviders.makeIterator()
                self.displayNextImage()
                
            }
        }
    }
}
