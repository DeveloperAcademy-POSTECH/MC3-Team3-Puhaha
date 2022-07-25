//
//  ReactionView.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/24.
//

import UIKit

class ReactionView: UIView {
    let reactionEmojiImageButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        var configuration = UIButton.Configuration.plain()
        configuration.background.image = UIImage(named: "AddReactionButtonImage")
        button.configuration = configuration
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        return button
    }()
    
    let reactedUserNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .blue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [reactionEmojiImageButton].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureEmojiImage(reaction: Reaction) {
        reactionEmojiImageButton.configuration?.background.image = UIImage(named: "ReactionBackgroundImage")
        reactionEmojiImageButton.frame = CGRect(x: 0, y: 0, width: 60, height: 67)
        reactionEmojiImageButton.setTitle(reaction.reactionEmojiString, for: .normal)
        reactionEmojiImageButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 9, trailing: 0)
        reactedUserNameLabel.text = reaction.reactedUserName
    }

    private func setConstraints() {
//        reactionEmojiImageButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            reactionEmojiImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            reactionEmojiImageButton.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
