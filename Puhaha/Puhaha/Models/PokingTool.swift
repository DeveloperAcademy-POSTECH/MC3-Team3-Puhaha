//
//  ForkTool.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/18.
//

import Foundation
import UIKit

enum Tool: Int, CaseIterable {
    
    case Fork = 0   // 포크
    case Spoon      // 숟가락
    case Whisk      // 거품기
    case Spatula    // 뒤집개
    
    var imageFileName: String {
        switch self {
        case .Fork:
            return "Fork"
        case .Spoon:
            return "Spoon"
        case .Whisk:
            return "Whisk"
        case .Spatula:
            return "Spatula"
        }
    }
}

class PokeTool {
    
    var tool: Tool
    var color: UIColor
    
    init(tool: Tool, color: UIColor) {
        self.tool = tool
        self.color = color
    }
}

#if DEBUG
// 더미데이터입니다 빠밤
extension PokeTool {
    static var dummyData = PokeTool(tool: Tool.Fork, color: UIColor.customBlue)
}

let toolImages = ["silver_fork", "silver_spoon", "silver_whisk", "silver_spatula_ver2"]

#endif
