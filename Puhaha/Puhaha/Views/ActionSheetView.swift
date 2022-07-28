//
//  ActionSheetView.swift
//  Puhaha
//
//  Created by Lena on 2022/07/19.
//

import UIKit
import PhotosUI

class ActionSheetView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(sampleCameraButton)
        configureConstraints()
    }
    
    lazy var chosenImageView: UIImageView = {
       let image = UIImageView()
        return image
    }()
    
    lazy var sampleCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .yellow
        button.layer.cornerRadius = 16
        button.layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(tapCameraButton(_ :)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    @objc func tapCameraButton(_ sender: Any) {
        if let button = sender as? UIButton {
            let sheet = UIAlertController(title: "식사 업로드하기", message: nil, preferredStyle: .actionSheet)
            let takePhoto = UIAlertAction(title: "사진 촬영하기", style: .default) {(_: UIAlertAction) in
                self.presentCamera()
            }
            let chooseLibarary = UIAlertAction(title: "라이브러리에서 선택하기", style: .default) {(_: UIAlertAction) in
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
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func newImageView(image: UIImage?) -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.image = image
        return imageView
    }
    
    private func configureConstraints() {
        sampleCameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sampleCameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sampleCameraButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
    }
}

extension ActionSheetView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        print("itemProvider:\(String(describing: itemProvider))")
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                print("itemProvider:\(String(describing: itemProvider))")
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else { return print("selected Image error")}
                    
                    let uploadViewController = UploadViewController()
                    uploadViewController.pictureImageView.image = selectedImage
//                    let selectedImageString = selectedImage?.imageToString()
//                    print("selectedImageString: \(selectedImageString)")
//                    uploadViewController.deliveredImageString = selectedImageString ?? String()
//
//                    print("selectedImageString: \(selectedImageString)")
//
                    uploadViewController.modalPresentationStyle = .fullScreen
                    
                    self.present(uploadViewController, animated: true)
                }
            }
        } else {
            print("load failed")
        }
    }
}

extension UIImage {
    /// 이미지 전달을 위해 string으로 변환해주는 메서드
    func imageToString() -> String? {
        let pngData = pngData()
        return pngData?.base64EncodedString(options: .lineLength64Characters)
    }
}

extension String {
    /// 이미지를 받아오기 위해 string에서 이미지로 변환해주는 메서드
    func stringToImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
}
