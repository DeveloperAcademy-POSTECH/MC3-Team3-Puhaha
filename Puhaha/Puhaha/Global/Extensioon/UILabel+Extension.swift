//
//  UILabel+Extension.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/31.
//

import UIKit

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment

        let mutableAttributedString = NSMutableAttributedString()
        if self.attributedText != nil {
            mutableAttributedString.append(self.attributedText ?? NSMutableAttributedString() )
        } else {
            mutableAttributedString.append(NSMutableAttributedString(string: self.text ?? ""))
            mutableAttributedString.addAttribute(NSAttributedString.Key.font,
                                                 value: self.font as Any,
                                                 range: NSMakeRange(0, mutableAttributedString.length))
        }
        mutableAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                             value: paragraphStyle,
                                             range: NSMakeRange(0, mutableAttributedString.length))
        self.attributedText = mutableAttributedString
    }
}
