//
//  ReactionCollectionViewCell.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/24.
//

import UIKit

class ReactionCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ReactionCollectionViewCell"
    
    let reactionEmojiBackgroundView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 67))
        imageView.image = UIImage(named: "AddReactionButtonImage")
        return imageView
    }()
    
    let reactionEmojiLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    let reactedUserNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [reactionEmojiBackgroundView, reactionEmojiLabel, reactedUserNameLabel].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureEmojiImage(with reaction: Reaction?) {
        if reaction == nil {
            reactionEmojiBackgroundView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            reactionEmojiBackgroundView.image = UIImage(named: "AddReactionButtonImage")
            reactedUserNameLabel.text = ""
            reactionEmojiBackgroundView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        } else {
            reactionEmojiBackgroundView.frame = CGRect(x: 0, y: 0, width: 60, height: 67)
            reactionEmojiBackgroundView.image = UIImage(named: "ReactionBackgroundImage")
            reactionEmojiLabel.text = reaction?.reactionEmojiString
            reactedUserNameLabel.text = reaction?.reactedUserName
            reactionEmojiBackgroundView.widthAnchor.constraint(equalToConstant: 67).isActive = true
        }
    }
    
    private func setConstraints() {
        reactionEmojiBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        reactionEmojiLabel.translatesAutoresizingMaskIntoConstraints = false
        reactedUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reactionEmojiBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            reactionEmojiBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reactionEmojiBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            reactionEmojiLabel.topAnchor.constraint(equalTo: topAnchor),
            reactionEmojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            reactionEmojiLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            reactionEmojiLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 60),
            
            reactedUserNameLabel.centerXAnchor.constraint(equalTo: reactionEmojiBackgroundView.centerXAnchor),
            reactedUserNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            reactedUserNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            reactedUserNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
