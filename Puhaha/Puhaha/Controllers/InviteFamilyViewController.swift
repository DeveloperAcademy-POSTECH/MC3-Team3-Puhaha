//
//  InviteFamilyViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/28.
//

import UIKit

class InviteFamilyViewController: UIViewController {
    private var createdRoomCode: String = UUID().uuidString
    
    private let guideMessageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.textColor = UIColor(named: "InfoLabelColor")
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "아래 초대링크를 복사해서\n가족 구성원들에게 공유하세요"
        return label
    }()
    
    private let roomCodeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor(named: "RoomCodeTextColor")
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let roomCodeCopyButton: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .medium)
        
        var titleAttr = AttributedString.init("복사하기")
        titleAttr.font = .boldSystemFont(ofSize: 14)
        titleAttr.foregroundColor = UIColor(named: "HelloMessageLabelColor")
        
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.baseForegroundColor = .black
        buttonConfiguration.imagePadding = 3
        
        let button: UIButton = UIButton()
        button.configuration = buttonConfiguration
        button.setImage(UIImage(systemName: "rectangle.portrait.on.rectangle.portrait", withConfiguration: imageConfiguration), for: .normal)
        button.alpha = 0.85
        
        return button
    }()
    
    private let roomCodeStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.customYellow.cgColor
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var enterFamilyRoomButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("입장하기", for: .normal)
        button.setTitleColor(UIColor(named: "ButtonTitleColor"), for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        button.backgroundColor = .customYellow
        button.layer.cornerRadius = 8
        
        button.addTarget(self,
                         action: #selector(enterFamilyRoomButtonTapped),
                         for: .touchUpInside)
        
        return button
    }()
    
    @objc private func enterFamilyRoomButtonTapped() {
        // TODO: 가족 코드 db에 입력
        UserDefaults.standard.set(createdRoomCode, forKey: "roomCode")        
        let mainTabViewController = MainTabViewController()
        self.navigationController?.pushViewController(mainTabViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        roomCodeStackView.layoutMargins = UIEdgeInsets(top: 0, left: roomCodeCopyButton.intrinsicContentSize.width / 2 - 8, bottom: 0, right: 0)
        
        [roomCodeLabel, roomCodeCopyButton].forEach {
            roomCodeStackView.addArrangedSubview($0)
        }
        
        [guideMessageLabel, roomCodeStackView, enterFamilyRoomButton].forEach {
            view.addSubview($0)
        }
        
        roomCodeLabel.text = createdRoomCode
        roomCodeLabel.text = createdRoomCode
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        guideMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        roomCodeStackView.translatesAutoresizingMaskIntoConstraints = false
        enterFamilyRoomButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            guideMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -guideMessageLabel.intrinsicContentSize.height),
            
            roomCodeStackView.heightAnchor.constraint(equalToConstant: 74),
            roomCodeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            roomCodeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            roomCodeStackView.topAnchor.constraint(equalTo: guideMessageLabel.bottomAnchor, constant: 33),
            
            enterFamilyRoomButton.heightAnchor.constraint(equalToConstant: 57),
            enterFamilyRoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            enterFamilyRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            enterFamilyRoomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -82)
        ])
    }
}
