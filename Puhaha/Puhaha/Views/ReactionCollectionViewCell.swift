//
//  ReactionCollectionViewCell.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/24.
//

import UIKit

class ReactionCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ReactionCollectionViewCell"
    
    let reactionEmojiImageButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 67))
        var configuration = UIButton.Configuration.plain()
        configuration.background.image = UIImage(named: "AddReactionButtonImage")
        button.configuration = configuration
        button.titleLabel?.font = UIFont.systemFont(ofSize: 64)
        return button
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
        
        [reactionEmojiImageButton, reactedUserNameLabel].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureEmojiImage(with reaction: Reaction?) {
        if reaction == nil {
            reactionEmojiImageButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            reactionEmojiImageButton.configuration?.background.image = UIImage(named: "AddReactionButtonImage")
            reactionEmojiImageButton.configuration?.background.imageContentMode = .top
            reactionEmojiImageButton.setTitle("", for: .normal)
            reactedUserNameLabel.text = ""
        } else {
            reactionEmojiImageButton.configuration?.background.image = UIImage(named: "ReactionBackgroundImage")
            reactionEmojiImageButton.setTitle(reaction?.reactionEmojiString, for: .normal)
            reactionEmojiImageButton.frame = CGRect(x: 0, y: 0, width: 60, height: 67)
            reactionEmojiImageButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 9, trailing: 0)
            reactedUserNameLabel.text = reaction?.reactedUserName
        }
    }
    
    private func setConstraints() {
        reactionEmojiImageButton.translatesAutoresizingMaskIntoConstraints = false
        reactedUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reactionEmojiImageButton.topAnchor.constraint(equalTo: topAnchor),
            reactionEmojiImageButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            reactionEmojiImageButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            reactionEmojiImageButton.bottomAnchor.constraint(equalTo: topAnchor, constant: 67),
            
            reactedUserNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            reactedUserNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            reactedUserNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            reactedUserNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
