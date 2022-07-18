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
}
