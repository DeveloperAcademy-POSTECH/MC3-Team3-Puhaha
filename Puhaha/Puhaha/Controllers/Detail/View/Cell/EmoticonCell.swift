//
//  EmoticonCell.swift
//  Puhaha
//
//  Created by JiwKang on 2022/08/09.
//

import UIKit

class EmoticonCell: UICollectionViewCell {
    static let identifier: String = "EmoticonCell"
    
    private let emoticon: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 27, height: 27))
        label.font = UIFont.systemFont(ofSize: 27)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(emoticon)
        emoticon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emoticon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureEmoji(emoji: String) {
        emoticon.text = emoji
    }
}
