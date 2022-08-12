//
//  ShadowUIViewExtension.swift
//  Puhaha
//
//  Created by JiwKang on 2022/08/12.
//

import UIKit

extension UIView {
    public func setCalendarShadow(radius: CGFloat, opacity: Float, offset: CGSize, width: CGFloat, height: CGFloat) {
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 13).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}
