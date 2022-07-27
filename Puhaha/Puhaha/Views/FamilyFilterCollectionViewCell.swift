//
//  FamilyFilterCollectionViewCell.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/19.
//

import UIKit

class FamilyFilterCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "FamilyFilterCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        [userIconImageView, familyNameLabel].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var userIconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 31, height: 31))
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private var familyNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.sizeToFit()
        return label
    }()
    
    func configureFilterCell(with family: Family) {
        userIconImageView.image = family.userIcon
        familyNameLabel.text = family.name
        if family.isSelected {
            backgroundColor = UIColor(named: "MainColor")
        } else {
            backgroundColor = UIColor(named: "FilterBackgroundUnselectedLightGray")
        }
    }
    
    private func setConstraints() {
        userIconImageView.translatesAutoresizingMaskIntoConstraints = false
        familyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userIconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            userIconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            userIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            userIconImageView.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 31),
            
            familyNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 32 / 3),
            familyNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

