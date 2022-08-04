//
//  EmptyMealCardView.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/23.
//

import UIKit

class EmptyMealCardView: UIView {
    var userTool: UIImage!
    
    private let stateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "아직 식사를 하지 않았어요."
        label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let pokeButton: UIButton = {
        let titleAttr = AttributedString.init("콕 찌르기")
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = titleAttr
        configuration.baseForegroundColor = .black
        configuration.imagePlacement = .top
        configuration.background.image = UIImage(named: "PokeButtonBackgroundImage")
        
        let button = UIButton(configuration: configuration)
        
        button.configurationUpdateHandler = { button in
            button.layer.opacity = button.isHighlighted ? 0.4 : 1
        }
        
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
    
    public func setButtonImage(toolImage: UIImage) {
        pokeButton.configuration?.image = imageRendering(image: toolImage)
    }
    
    private func imageRendering(image: UIImage) -> UIImage {
        let renderFormat = UIGraphicsImageRendererFormat.default()
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: UIScreen.main.bounds.width / 1.77, height: UIScreen.main.bounds.width / 1.77), format: renderFormat)
        let newImage = renderer.image { _ in
            image.draw(in: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 1.77, height: UIScreen.main.bounds.width / 1.77))
        }
        return newImage
    }
}
