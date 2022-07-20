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
        
        [firstTagLabel, secondTagLabel, thirdTagLabel].forEach {
            tagStack.addArrangedSubview($0)
        }
        
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
        var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var firstTagLabel: UILabel = {
        var label: UILabel = UILabel()
        label.textColor = .white
        label.layer.cornerRadius = 20
        return label
    }()
    var secondTagLabel: UILabel = {
        var label: UILabel = UILabel()
        label.textColor = .white
        label.layer.cornerRadius = 20
        return label
    }()
    var thirdTagLabel: UILabel = {
        var label: UILabel = UILabel()
        label.textColor = .white
        label.layer.cornerRadius = 20
        return label
    }()
    
    var tagStack: UIStackView = {
        var stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var gradation: UIImageView = {
        var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 209, height: 254))
        imageView.setTranparentGradientImage(startColor: UIColor(named: "GradientStartColor")!, middleColor: UIColor(named: "GradientMiddleColor")!, endColor: UIColor(named: "tranparent")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func configure(with meal: Meal) {
        mealImageView.image = meal.mealImage
        userNameLabel.text = meal.userName
        userIconImageView.image = meal.userIcon
        
        if meal.tag[0].content != "" {
            firstTagLabel.text = "#\(meal.tag[0].content)"
            firstTagLabel.backgroundColor = meal.tag[0].tagColor
        }
        
        if meal.tag[1].content != "" {
            secondTagLabel.text = "#\(meal.tag[1].content)"
            secondTagLabel.backgroundColor = meal.tag[1].tagColor
        }
        if meal.tag[2].content != "" {
            thirdTagLabel.text = "#\(meal.tag[2].content)"
            thirdTagLabel.backgroundColor = meal.tag[2].tagColor
        }
    }
    
    private func setConstraints() {
        mealImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mealImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mealImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mealImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        gradation.topAnchor.constraint(equalTo: topAnchor, constant: 221).isActive = true
        gradation.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        gradation.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gradation.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        userNameLabel.topAnchor.constraint(equalTo: gradation.topAnchor, constant: 18).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true

        userIconImageView.topAnchor.constraint(equalTo: userNameLabel.topAnchor).isActive = true
        userIconImageView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -94).isActive = true
        userIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        userIconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -88).isActive = true
        
        tagStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        tagStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
    }
}

extension UIImageView {
    func setTranparentGradientImage(startColor: UIColor, middleColor: UIColor, endColor: UIColor) {
        let gradient: CAGradientLayer = {
            let layout = CAGradientLayer()
            layout.colors = [endColor.cgColor, startColor.cgColor, startColor.cgColor]
            layout.frame = self.frame
            layout.locations = [0.0, 0.25, 1.0]
            layout.startPoint = CGPoint(x: 0.0, y: 0.0)
            layout.endPoint = CGPoint(x: 0.0, y: 2.0)
            
            return layout
        }()
        self.layer.insertSublayer(gradient, at: 1)
    }
}
