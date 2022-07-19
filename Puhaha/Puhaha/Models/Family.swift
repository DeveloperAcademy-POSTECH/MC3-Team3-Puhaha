//
//  Family.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/19.
//

import UIKit

struct Family {
    var name: String
    var userIcon: UIImage
}

#if DEBUG
extension Family {
    static var sampleFamilyMemebers = [
        Family(name: "모두", userIcon: UIImage(named: "icon-tab-bar-table")!),
        Family(name: "아빠", userIcon: UIImage(systemName: "circle")!),
        Family(name: "엄마", userIcon: UIImage(systemName: "circle")!),
        Family(name: "할머니", userIcon: UIImage(systemName: "circle")!),
        Family(name: "언니", userIcon: UIImage(systemName: "circle")!),
        Family(name: "오빠", userIcon: UIImage(systemName: "circle")!),
        Family(name: "나", userIcon: UIImage(systemName: "circle")!)
    ]
}
#endif
