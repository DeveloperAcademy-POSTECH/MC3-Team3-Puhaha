//
//  ArchiveCell.swift
//  Puhaha
//
//  Created by JiwKang on 2022/08/11.
//

import UIKit

class ArchiveCell: UICollectionViewCell {
    static let identifier: String = "ArchiveCell"
    
    private let mealImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private let timeStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        return stack
    }()
    
    private let uploadedUserNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .customTitleBlack
        return label
    }()
    
    private let stopwatchImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .customUploadTimeBlack
        return imageView
    }()
    
    private let uploadedTimeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .customUploadTimeBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        [stopwatchImageView, uploadedTimeLabel].forEach {
            timeStack.addArrangedSubview($0)
        }
        
        [uploadedUserNameLabel, timeStack].forEach {
            titleStack.addArrangedSubview($0)
        }
        
        [mealImageView, titleStack].forEach {
            addSubview($0)
        }
        
        configureConstraints()
        
        setShadow(radius: 6, opacity: 0.1, offset: CGSize(width: 0.0, height: 1.0), pathSize: CGSize(width: 150, height: 150))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: topAnchor),
            mealImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mealImageView.bottomAnchor.constraint(equalTo: topAnchor, constant: 150),
            
            titleStack.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 12),
            titleStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configureCell(meal: Meal) {
        mealImageView.image = meal.mealImage
        uploadedUserNameLabel.text = meal.uploadUser
        
        let uploadedTimeText = meal.uploadedTime.transferStringToDate()!.transferDateToStringDay()
        uploadedTimeLabel.text = " \(uploadedTimeText)"
    }
}
