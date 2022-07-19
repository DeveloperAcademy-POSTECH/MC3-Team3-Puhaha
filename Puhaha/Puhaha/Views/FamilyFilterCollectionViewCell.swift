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
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var familyNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with family: Family) {
        userIcon.image = family.userIcon
        familyNameLabel.text = family.name
    }
    
    private func setConstraints() {
        userIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        
        familyNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        familyNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
