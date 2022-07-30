//
//  CreateFamilyViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/28.
//

import UIKit
import SwiftUI

class CreateFamilyViewController: UIViewController {
    var userName: String = "박기웅"
    
    private let userNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor(named: "HelloMessageLabelColor")
        return label
    }()
    
    private let helloMessageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .light)
        label.textColor = UIColor(named: "HelloMessageLabelColor")
        label.text = " 님 안녕하세요"
        return label
    }()
    
    private let guideMessageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.textColor = UIColor(named: "InfoLabelColor")
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "가족 구성원들과\n코드를 공유하세요"
        return label
    }()
    
    private let createFamilyRoomButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("새로운 가족 방 생성하기", for: .normal)
        button.setTitleColor(UIColor(named: "ButtonTitleColor"), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "BasicButtonBorderColor")?.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let enterExistFamilyRoomButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("기존 가족 방에 입장하기", for: .normal)
        button.setTitleColor(UIColor(named: "ButtonTitleColor"), for: .normal)
        button.backgroundColor = .customYellow
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        [userNameLabel, helloMessageLabel, guideMessageLabel, createFamilyRoomButton, enterExistFamilyRoomButton].forEach {
            view.addSubview($0)
        }
        
        userNameLabel.text = userName
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        helloMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        guideMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        createFamilyRoomButton.translatesAutoresizingMaskIntoConstraints = false
        enterExistFamilyRoomButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            helloMessageLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            helloMessageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            guideMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            createFamilyRoomButton.heightAnchor.constraint(equalToConstant: 57),
            createFamilyRoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            createFamilyRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            createFamilyRoomButton.bottomAnchor.constraint(equalTo: enterExistFamilyRoomButton.topAnchor, constant: -20),
            
            enterExistFamilyRoomButton.heightAnchor.constraint(equalToConstant: 57),
            enterExistFamilyRoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            enterExistFamilyRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            enterExistFamilyRoomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -82)
        ])
    }
}
