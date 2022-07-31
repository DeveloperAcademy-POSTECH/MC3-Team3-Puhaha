//
//  PokingToolButton.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/29.
//

import UIKit.UIButton

class StyleButton: UIButton {
    
    var tool: Tool

    required init(tool: Tool) {
        
        self.tool = tool
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
}
