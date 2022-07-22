//
//  FamilyFilterCollectionViewCell.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/19.
//

import UIKit

class FamilyFilterCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [userIcon, familyNameLabel].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var userIcon: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 31, height: 31))
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var familyNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with family: Family) {
        userIcon.image = family.userIcon
        familyNameLabel.text = family.name
        if family.isSelected {
            backgroundColor = UIColor(named: "MainColor")
        } else {
            backgroundColor = UIColor(named: "FilterBackgroundUnselectedLightGray")
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userIcon.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            userIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            userIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            userIcon.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 31),
            
            familyNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 32 / 3),
            familyNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

