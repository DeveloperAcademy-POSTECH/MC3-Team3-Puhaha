//
//  User.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/31.
//

import UIKit

class User {
    private let accountId: String?
    private var name: String?
    private var loginForm: Int?

    private var toolImage: UIImage?
    private var toolType: String?
    private var toolColor: String?
    private var familyCodes: [String?]
    private var pokeState: Poke?
    
    init() {
        self.accountId = nil
        self.name = nil
        self.loginForm = 0

        self.toolImage = nil
        self.toolType = nil
        self.toolColor = nil
        self.familyCodes = []
        self.pokeState = nil
    }
    
    init(accountId: String) {
        self.accountId = accountId
        self.name = nil
        self.loginForm = 0

        self.toolImage = nil
        self.toolType = nil
        self.toolColor = nil
        self.familyCodes = []
        self.pokeState = nil
    }

    init(accountId: String, name: String) {
        self.accountId = accountId
        self.name = name
        self.loginForm = 0

        self.toolImage = nil
        self.toolType = nil
        self.toolColor = nil
        self.familyCodes = []
        self.pokeState = nil
    }

    init(accountId: String, name: String, toolImage: UIImage, toolType: String, toolColor: String, familyCodes: [String], pokeState: Poke) {
        
        self.accountId = accountId
        self.name = name
        self.loginForm = 0

        self.toolImage = toolImage
        self.toolType = toolType
        self.toolColor = toolColor
        self.familyCodes = familyCodes
        self.pokeState = pokeState
    }
    
    public func setName(name: String) {
        self.name = name
    }
    public func getName() -> String {
        return name ?? ""
    }
    
    public func setFamilyCodes(code: [String]) {
        self.familyCodes = code
    }
    public func getFamilyCodes() -> [String?] {
        return familyCodes // ?? [String()]
    }
    
    public func setToolImage(toolImage: UIImage) {
        self.toolImage = toolImage
    }
    public func getToolImage() -> UIImage {
        return toolImage ?? UIImage()
    }
    
    public func setToolType(with tool: String) {
        self.toolType = tool
    }
    public func getToolType() -> String {
        return toolType ?? ""
    }
    
    public func setToolColor(with color: String) {
        self.toolColor = color
    }
    public func getToolColor() -> String {
        return toolColor ?? ""
    }
    
    public func setPoke(poke: Poke) {
        self.pokeState = poke
    }
}

// setToolColor(with: "Yellow")
