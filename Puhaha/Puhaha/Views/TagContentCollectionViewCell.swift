//
//  TagContentCollectionViewCell.swift
//  Puhaha
//
//  Created by Lena on 2022/07/25.
//

 import UIKit

 class TagContentCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TagContentCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(contentLabel)
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCellConstraints()
    }

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

     private func configureCellConstraints() {
         NSLayoutConstraint.activate([
            contentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
         ])
     }
 }
