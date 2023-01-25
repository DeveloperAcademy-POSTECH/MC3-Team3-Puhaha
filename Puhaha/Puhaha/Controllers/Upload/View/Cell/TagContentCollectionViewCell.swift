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
        contentView.addSubview(tagLabel)
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

     lazy var tagLabel: TagLabel = {
         let label = TagLabel(frame: .zero)
         label.translatesAutoresizingMaskIntoConstraints = false

         return label
     }()

     private func configureCellConstraints() {
         NSLayoutConstraint.activate([
            tagLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
         ])
     }
}
