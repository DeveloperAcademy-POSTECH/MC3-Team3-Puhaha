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
