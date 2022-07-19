//
//  MealCollectionViewCell.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/19.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [gradation, mealImageView, userNameLabel, userIconImageView].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mealImageView: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.layer.zPosition = -1
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var userNameLabel: UILabel = {
        var label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var userIconImageView: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var gradation: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "MainColor")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func configure(with meal: Meal) {
        mealImageView.image = meal.mealImage
        userNameLabel.text = meal.userName
        userIconImageView.image = meal.userIcon
    }
    
    private func setConstraints() {
        mealImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mealImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mealImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mealImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        userNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -96).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        
        gradation.topAnchor.constraint(equalTo: topAnchor, constant: 254).isActive = true
        gradation.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        gradation.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gradation.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
