//
//  PokeState.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/31.
//

import UIKit

struct PokeState {
    private let pokedBy: String
    private let pokedTime: Date
    
    init() {
        self.pokedBy = ""
        self.pokedTime = Date()
    }
}
