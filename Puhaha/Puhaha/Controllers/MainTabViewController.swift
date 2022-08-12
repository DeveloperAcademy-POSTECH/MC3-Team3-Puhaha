//
//  MainTabViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/20.
//

import UIKit
import PhotosUI

class MainTabViewController: UITabBarController {
    
    private let cameraButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.setImage(UIImage(named: "EggFriedImage"), for: .normal)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
            cameraButton.frame = CGRect(x: view.bounds.width/2 - 40, y: UIScreen.main.bounds.height - tabBar.bounds.height - 40, width: 80, height: 80)
        } else {
            cameraButton.frame = CGRect(x: view.bounds.width - tabBar.bounds.height * 1.5, y: UIScreen.main.bounds.height - tabBar.bounds.height - tabBar.bounds.height * 1.5, width: tabBar.bounds.height, height: tabBar.bounds.height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let tableTab = MainViewController()
        tableTab.tabBarItem = UITabBarItem(title: "식탁", image: UIImage(named: "icon-tab-bar-table") ?? UIImage(), selectedImage: UIImage(named: "icon-tab-bar-table") ?? UIImage())
        tableTab.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -4, right: 0)
        tableTab.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 6.0)
        
        let achieveTab = AchieveViewController()
        achieveTab.tabBarItem = UITabBarItem(title: "통계", image: UIImage(named: "icon-tab-bar-statistic") ?? UIImage(), selectedImage: UIImage(named: "icon-tab-bar-statistic") ?? UIImage())
        achieveTab.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -4, right: 0)
        achieveTab.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 6.0)
        
        viewControllers = [tableTab, achieveTab]
        tabBar.tintColor = UIColor(named: "TabBarIconSelectedColor") ?? UIColor()
        tabBar.unselectedItemTintColor = UIColor(named: "TabBarIconUnSelectedColor")
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
        
        cameraButton.addTarget(self, action: #selector(tapCameraButton(_ :)), for: .touchUpInside)
        view.addSubview(cameraButton)
        
        let configuration = PHPickerConfiguration()
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
    }
    
    /// 카메라 촬영화면을 모달로 띄우는 함수
    private func presentCamera() {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.cameraDevice = .rear
        camera.cameraCaptureMode = .photo
        camera.delegate = self
        present(camera, animated: true)
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
    
    @objc func tapCameraButton(_ sender: UIButton) {
        let sheet = UIAlertController(title: "식사 업로드하기", message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "사진 촬영하기", style: .default) {(_: UIAlertAction) in
            self.presentCamera()
        }
        let chooseFromLibrary = UIAlertAction(title: "라이브러리에서 선택하기", style: .default) {(_: UIAlertAction) in
            self.selectPhotos()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [takePhoto, chooseFromLibrary, cancel].forEach { sheet.addAction($0)}
        
        self.present(sheet, animated: true)
    }
}

/**
 tab bar shadow
 출처: https://velog.io/@leejh3224/iOS-TabBar-shadow-커스터마이징-trjugzee87
 */
extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.50,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur
    }
}

extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
