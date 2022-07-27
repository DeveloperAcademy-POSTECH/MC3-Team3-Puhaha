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
        button.alignTitleBelowImage(spacing: 16)
        
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
            stateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 72),
            stateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width / 8.67),
            stateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(UIScreen.main.bounds.width / 8.67)),
            stateLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 72 + stateLabel.intrinsicContentSize.height),
            
            pokeButton.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 53),
            pokeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width / 8.67),
            pokeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(UIScreen.main.bounds.width / 8.67)),
            pokeButton.bottomAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 53 + UIScreen.main.bounds.width * 0.77)
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
    func alignTitleBelowImage(spacing: CGFloat = 8.0) {
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
        
        titleEdgeInsets = UIEdgeInsets(top: self.intrinsicContentSize.height * 4 - spacing, left: -image.size.width, bottom: titleSize.height / 2, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: spacing, right: -titleSize.width)
    }
}
