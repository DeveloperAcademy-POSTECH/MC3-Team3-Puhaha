//
//  Poke.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/31.
//
import Foundation

class Poke {
    private let pokedBy: String
    private let pokedTime: String
    
    init() {
        self.pokedBy = ""
        self.pokedTime = ""
    }
    
    init(pokedBy: String, pokedTime: String) {
        self.pokedBy = pokedBy
        self.pokedTime = pokedTime
    }
}
