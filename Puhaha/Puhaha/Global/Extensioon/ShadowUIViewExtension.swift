//
//  ShadowUIViewExtension.swift
//  Puhaha
//
//  Created by JiwKang on 2022/08/12.
//

import UIKit

extension UIView {
    public func setShadow(radius: CGFloat, opacity: Float, offset: CGSize, pathSize: CGSize) {
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: pathSize.width, height: pathSize.height), cornerRadius: 13).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}
