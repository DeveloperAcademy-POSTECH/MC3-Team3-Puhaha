//
//  Tag.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/18.
//

import Foundation
import UIKit

struct Tag {
    let content: String
    let tagColor: UIColor
}

#if DEBUG
extension Tag {
    static var sampleTag: [Tag] = [
        Tag(content: "오늘 점저", tagColor: UIColor(named: "TagColorViolet")!),
        Tag(content: "꿀맛", tagColor: UIColor(named: "TagColorPink")!),
        Tag(content: "디저트", tagColor: UIColor(named: "TagColorPastelBlue")!)
    ]
}
#endif
