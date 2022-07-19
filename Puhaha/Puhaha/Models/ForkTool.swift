//
//  ForkTool.swift
//  Puhaha
//
//  Created by 김보영 on 2022/07/18.
//

import Foundation
import UIKit

enum Tool {
    case Spoon      // 숟가락
    case Fork       // 포크
    case Whisk      // 거품기
    case Spatula    // 뒤집개
}

struct ForkTool {
    var tool: Tool
    var color: UIColor
}

#if DEBUG
extension ForkTool {
    static var dummyData: [ForkTool] = [
        ForkTool(tool: Tool.Fork, color: UIColor(rgb: 0x6A94D1)),
        ForkTool(tool: Tool.Fork, color: UIColor(rgb: 0x6A94D1)),
        ForkTool(tool: Tool.Fork, color: UIColor(rgb: 0x6A94D1))
    ]
}
#endif
