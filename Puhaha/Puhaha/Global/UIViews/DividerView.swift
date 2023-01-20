//
//  DividerView.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/26.
//

import UIKit.UIView

/// 수평선을 그려주는 UIView로,
/// argument로 divider의 높이와 색상, 그리고 divider를 포함할 상위 뷰를 넣어줍니다.
func UIHorizontalDividerView(height: CGFloat, color: UIColor) -> UIView {
    
    let divider = UIView()
    divider.backgroundColor = color
    divider.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
        divider.heightAnchor.constraint(equalToConstant: height)
    ])
    
    return divider
}
