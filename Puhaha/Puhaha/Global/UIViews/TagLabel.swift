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
        return label
    }()
    
    var tagBackground: UIView = {
        var view: UIView = UIView()
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
    
    func setTextAndBackgroundColor(tag: Tag, fontSize: CGFloat) {
        if tag.content == "" {
            return
        }
        
        tagLabel.font = UIFont.systemFont(ofSize: fontSize)
        tagLabel.text = tag.content
        tagLabel.frame = CGRect(x: tagLabel.font.pointSize / 1.2, y: tagLabel.font.pointSize / 2.6, width: tagLabel.intrinsicContentSize.width, height: tagLabel.intrinsicContentSize.height)
        
        tagBackground.layer.cornerRadius = fontSize
        tagBackground.backgroundColor = tag.backgroundColor
        tagBackground.frame = CGRect(x: 0, y: 0, width: tagLabel.font.pointSize / 0.6 + tagLabel.intrinsicContentSize.width, height: tagLabel.intrinsicContentSize.height + tagLabel.font.pointSize / 1.3)
    }
}
