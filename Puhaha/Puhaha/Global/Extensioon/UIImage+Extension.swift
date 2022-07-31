//
//  UIImage+Extension.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/28.
//

import UIKit.UIImage

// 이미지의 alpha값을 조정하는 메소드
// 출처: https://stackoverflow.com/a/28517867
extension UIImage {

    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
