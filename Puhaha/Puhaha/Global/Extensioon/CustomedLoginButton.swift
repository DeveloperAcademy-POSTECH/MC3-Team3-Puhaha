//
//  CustomedLoginButton.swift
//  Puhaha
//
//  Created by κΉμν on 2022/07/19.
//

import UIKit

class CustomedLoginButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
    }
}
