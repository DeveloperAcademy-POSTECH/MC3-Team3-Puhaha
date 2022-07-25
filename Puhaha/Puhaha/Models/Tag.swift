//
//  Tag.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import UIKit

struct Tag {
    let content: String
    let backgroundColor: UIColor
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