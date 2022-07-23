//
//  MealCardCollectionViewCell.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/19.
//

import UIKit

class MealCardCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "MealCardCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [gradation, mealImageView, userNameLabel, userIconImageView, tagStack].forEach {
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
        imageView.sizeToFit()
        return imageView
    }()
    
    var userNameLabel: UILabel = {
        var label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        return label
    }()
    
    var userIconImageView: UIImageView = {
        var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()
    
    var tagLabels: [TagLabel] = []
    
    var tagStack: UIStackView = {
        var stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .fill
        return stackView
    }()
    
    var gradation: UIImageView = {
        var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 1.86, height: UIScreen.main.bounds.height / 3.32))
        imageView.image = UIImage(named: "GradientImage")
        return imageView
    }()
    
    func configureMealCard(with meal: Meal) {
        mealImageView.image = meal.mealImage
        userNameLabel.text = meal.userName
        userIconImageView.image = meal.userIcon
        
        for tag in meal.tags {
            let tagLabel = TagLabel()
            tagLabel.setTextAndBackgroundColor(tag: tag)
            tagLabels.append(tagLabel)
        }
        
        tagLabels.forEach {
            tagStack.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userIconImageView.translatesAutoresizingMaskIntoConstraints = false
        tagStack.translatesAutoresizingMaskIntoConstraints = false
        gradation.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: topAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            gradation.topAnchor.constraint(equalTo: topAnchor, constant: contentView.bounds.height / 2.49),
            gradation.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: gradation.bottomAnchor, constant: -(contentView.bounds.height / 3.34)),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            
            userIconImageView.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            userIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            
            tagStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            tagStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            tagStack.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: contentView.bounds.height / 17.67)
        ])
    }
}
