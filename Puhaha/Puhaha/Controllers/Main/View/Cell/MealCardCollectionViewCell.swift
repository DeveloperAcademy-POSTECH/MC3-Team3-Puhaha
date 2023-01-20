//
//  MealCardCollectionViewCell.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/19.
//

import UIKit

class MealCardCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "MealCardCollectionViewCell"
    
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
    
    var mealCardTagStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var gradient: UIImageView = {
        var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 1.86, height: UIScreen.main.bounds.height / 3.32))
        imageView.image = UIImage(named: "GradientImage")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for _ in 0..<3 {
            mealCardTagStackView.addArrangedSubview(TagLabel())
        }
        
        layer.cornerRadius = 33
        layer.masksToBounds = true
        
        [gradient, mealImageView, userNameLabel, userIconImageView, mealCardTagStackView].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureMealCard(with meal: Meal) {
        mealImageView.image = meal.mealImage
        userIconImageView.image = meal.userIcon
        userNameLabel.text = meal.uploadUser
        
        for i in 0..<mealCardTagStackView.subviews.count {
            (mealCardTagStackView.subviews[i] as? TagLabel ?? TagLabel()).setTextAndBackgroundColor(tag: meal.tags[i], fontSize: 10)
        }
    }
    
    private func setConstraints() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userIconImageView.translatesAutoresizingMaskIntoConstraints = false
        mealCardTagStackView.translatesAutoresizingMaskIntoConstraints = false
        gradient.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: topAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            gradient.topAnchor.constraint(equalTo: topAnchor, constant: contentView.bounds.height / 2.49),
            gradient.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradient.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: gradient.bottomAnchor, constant: -(contentView.bounds.height / 3.34)),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            
            userIconImageView.heightAnchor.constraint(equalToConstant: 83),
            userIconImageView.widthAnchor.constraint(equalToConstant: 83),
            userIconImageView.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            userIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            
            mealCardTagStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            mealCardTagStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            mealCardTagStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(contentView.bounds.height / 13.7))
        ])
    }
}
