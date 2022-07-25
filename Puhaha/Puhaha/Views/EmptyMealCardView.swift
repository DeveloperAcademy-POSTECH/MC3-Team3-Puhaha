//
//  EmptyMealCardView.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/23.
//

import UIKit

class EmptyMealCardView: UIView {
    private let stateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "아직 식사를 하지 않았어요."
        label.font = UIFont.systemFont(ofSize: 26)
        return label
    }()
    
    // TODO: 버튼의 스타일이 확정되면 수정 필요 -
    private let pokeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Spoon") ?? UIImage(), for: .normal)
        button.setTitle("콕 찌르기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.alignTextBelow()
        
        button.setBackgroundImage(UIImage(named: "PokeButtonBackgroundImgae"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [stateLabel, pokeButton].forEach {
            addSubview($0)
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        pokeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 72),
            
            pokeButton.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 53),
            
            pokeButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension UIButton {
    /**
     버튼 내부 이미지와 텍스트 vertical 정렬하는 함수
     출처: https://velog.io/@ezidayzi/iOS-UIButton-title-image-align-하기
     해당 함수는 ios 15부터 사용되지 않는 함수들을 사용하기 때문에 디자인이 확정되면 아래 링크를 참고하는 방식으로 바꿔야 한다.
     UIButton.Configuration apple doc 링크:  https://developer.apple.com/documentation/uikit/uibutton/configuration
     */
    func alignTextBelow(spacing: CGFloat = 8.0) {
        guard let image = self.imageView?.image else {
            return
        }
        
        guard let titleLabel = self.titleLabel else {
            return
        }
        
        guard let titleText = titleLabel.text else {
            return
        }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])
        
        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}
