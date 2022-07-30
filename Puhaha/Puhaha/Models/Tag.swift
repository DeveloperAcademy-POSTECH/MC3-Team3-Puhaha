//
//  Tag.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import UIKit.UIColor

struct Tag {
    let content: String
    let backgroundColor: UIColor?
    
    init(content: String) {
        self.content = content
        self.backgroundColor = nil
    }
    
    init(content: String, backgroundColor: UIColor?) {
        self.content = content
        self.backgroundColor = backgroundColor
    }
}

#if DEBUG
extension Tag {
    static var sampleTag: [Tag] = [
        Tag(content: "오늘 점저", backgroundColor: UIColor(named: "VioletTagBackgroundColor")!),
        Tag(content: "꿀맛", backgroundColor: UIColor(named: "PinkTagBackgroundColor")!),
        Tag(content: "디저트", backgroundColor: UIColor(named: "PastelBlueTagBackgroundColor")!)
    ]
}
#endif
