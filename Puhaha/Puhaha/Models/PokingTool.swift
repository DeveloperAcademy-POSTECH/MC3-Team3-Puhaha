//
//  ForkTool.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/18.
//

import Foundation
import UIKit

enum Tool {
    case Fork       // 포크
    case Spoon      // 숟가락
    case Whisk      // 거품기
    case Spatula    // 뒤집개
}

class PokeTool {
    var tool: Tool
    var color: UIColor
    
    init(tool: Tool, color: UIColor) {
        self.tool = tool
        self.color = color
    }
    
    func toolToString() -> String {
        switch tool {
        case Tool.Fork:
            return "Fork"
        case Tool.Spoon:
            return "Spoon"
        case Tool.Whisk:
            return "Whisk"
        default:
            return "Spatula"
        }
    }
    
    func toolToInt() -> Int {
        switch tool {
        case Tool.Fork:
            return 0
        case Tool.Spoon:
            return 1
        case Tool.Whisk:
            return 2
        default:
            return 3
        }
    }
}

#if DEBUG
// 더미데이터입니다 빠밤
extension PokeTool {
    static var dummyData = PokeTool(tool: Tool.Fork, color: UIColor.customBlue)
}

//let toolImages = [UIImage(contentsOfFile: "silver_fork"), UIImage(contentsOfFile: "silver_spoon"), UIImage(contentsOfFile: "silver_whisk"), UIImage(contentsOfFile: "silver_spatula_ver2")]
let toolImages = ["silver_fork", "silver_spoon", "silver_whisk", "silver_spatula_ver2"]

#endif
