//
//  CustomedLoginButton.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/19.
//

import UIKit

class CustomedLoginButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.widthAnchor.constraint(equalToConstant: 338).isActive = true
        self.heightAnchor.constraint(equalToConstant: 57).isActive = true
    }
}
