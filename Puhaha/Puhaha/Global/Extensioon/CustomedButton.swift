//
//  CustomedButton.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/19.
//

import UIKit

class CustomedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8.0
        self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.065).isActive = true
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.85).isActive = true
    }
}
