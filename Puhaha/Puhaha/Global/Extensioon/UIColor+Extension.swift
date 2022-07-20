//
//  UIColor+Extension.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/18.
//

import Foundation
import UIKit

// MARK: hex color value
// Hex color value값을 저장하기 위해 가져온 extension
// https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    /*
     사용 방법
     let color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
     let color2 = UIColor(rgb: 0xFFFFFF)
     */
    
}

// MARK: 임의로 넣은 값이라 수정 필요
extension UIColor {

    static var bobRed: UIColor {
        return UIColor(rgb: 0xE86334)
        // 다홍색
    }
    
    static var bobPurple: UIColor {
        return UIColor(rgb: 0x7B65FF)
        // 보라색
    }
    
    static var bobBlue: UIColor {
        return UIColor(rgb: 0x6A94D1)
        // 파란색
    }
    
    static var bobYellow: UIColor {
        return UIColor(rgb: 0xFFCC1E)
        // 노란색
    }
    
    static var bobBlack: UIColor {
        return UIColor(rgb: 0x2C213A)
        // 검은색
    }
}

#if DEBUG

let toolColors = [UIColor.bobRed, UIColor.bobBlue, UIColor.bobYellow, UIColor.bobBlack, UIColor.bobPurple]

#endif
