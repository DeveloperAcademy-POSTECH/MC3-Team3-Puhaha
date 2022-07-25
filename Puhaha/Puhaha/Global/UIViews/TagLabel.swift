//
//  TagLabel.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/21.
//

import UIKit

class TagLabel: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [tagBackground, tagLabel].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tagLabel: UILabel = {
        var label: UILabel = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    var tagBackground: UIView = {
        var view: UIView = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.zPosition = -1
        return view
    }()

    private func setConstraints() {
        NSLayoutConstraint.activate([
            tagLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tagLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tagBackground.centerXAnchor.constraint(equalTo: centerXAnchor),
            tagBackground.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setTextAndBackgroundColor(tag: Tag) {
        if tag.content == "" {
            return
        }
        
        tagLabel.text = tag.content
        tagLabel.frame = CGRect(x: tagLabel.intrinsicContentSize.width / 4, y: tagLabel.intrinsicContentSize.height / 2, width: tagLabel.intrinsicContentSize.width, height: tagLabel.intrinsicContentSize.height)
        tagBackground.backgroundColor = tag.tagColor
        tagBackground.frame = CGRect(x: 0, y: 0, width: tagLabel.intrinsicContentSize.width / 2 + tagLabel.intrinsicContentSize.width, height: tagLabel.intrinsicContentSize.height + tagLabel.intrinsicContentSize.height)
    }
}
