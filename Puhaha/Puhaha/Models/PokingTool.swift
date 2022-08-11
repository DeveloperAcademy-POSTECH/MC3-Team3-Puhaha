//
//  ForkTool.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/18.
//

import Foundation
import UIKit.UIColor

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

func convertStringToToolType(string value: String) -> Tool {
    
    switch value {
    case "Fork":
        return Tool.Fork
    case "Spoon":
        return Tool.Spoon
    case "Whisk":
        return Tool.Whisk
    default:
        return Tool.Spatula
    }
}

func convertStringToToolColor(string value: String) -> UIColor {
    switch value {
    case "Silver":
        return UIColor.customLightGray
    case "Blue":
        return UIColor.customBlue
    case "Black":
        return UIColor.customBlack
    case "Yellow":
        return UIColor.customYellow
    default:
        return UIColor.customPurple
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

let toolImages = ["silver_fork", "silver_spoon", "silver_whisk", "silver_spatula_ver2"]

#endif
