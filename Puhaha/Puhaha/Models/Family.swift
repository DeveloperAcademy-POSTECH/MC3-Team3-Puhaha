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
    var isSelected: Bool = false
}

#if DEBUG
extension Family {
    static var sampleFamilyMembers = [
        Family(name: "모두", userIcon: UIImage(named: "IconEveryoneFilter")!, isSelected: true),
        Family(name: "콜리", userIcon: UIImage(named: "Colli")!),
        Family(name: "키", userIcon: UIImage(named: "Key")!),
        Family(name: "레나", userIcon: UIImage(named: "Lena")!),
        Family(name: "티모", userIcon: UIImage(named: "Teemo")!),
        Family(name: "우기", userIcon: UIImage(named: "Woogy")!)
    ]
}
#endif
