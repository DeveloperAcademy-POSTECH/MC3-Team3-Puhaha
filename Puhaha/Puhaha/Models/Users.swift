//
//  User.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/31.
//

import UIKit

class Users {
    private let accountId: String
    private let loginForm: Int
    private let familyCode: String
    
    private let name: String
    private let pokingTool: PokeTool
    private let pokeState: PokeState
    
    init(accountId: String, name: String) {
        self.accountId = accountId
        self.loginForm = 0
        self.familyCode = ""
        
        self.name = name
        self.pokingTool = PokeTool(tool: .Fork, color: .customLightGray)
        self.pokeState = PokeState()
    }
}
