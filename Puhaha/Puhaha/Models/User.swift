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
    private var familyCode: String?
    private var pokeState: Poke?
    
    init() {
        self.accountId = nil
        self.name = nil
        self.loginForm = 0

        self.toolImage = nil
        self.toolType = nil
        self.toolColor = nil
        self.familyCode = nil
        self.pokeState = nil
    }
    
    init(accountId: String) {
        self.accountId = accountId
        self.name = nil
        self.loginForm = 0

        self.toolImage = nil
        self.toolType = nil
        self.toolColor = nil
        self.familyCode = nil
        self.pokeState = nil
    }

    init(accountId: String, name: String) {
        self.accountId = accountId
        self.name = name
        self.loginForm = 0

        self.toolImage = nil
        self.toolType = nil
        self.toolColor = nil
        self.familyCode = nil
        self.pokeState = nil
    }

    init(accountId: String, name: String, toolImage: UIImage, toolType: String, toolColor: String, familyCode: String, pokeState: Poke) {
        
        self.accountId = accountId
        self.name = name
        self.loginForm = 0

        self.toolImage = toolImage
        self.toolType = toolType
        self.toolColor = toolColor
        self.familyCode = familyCode
        self.pokeState = pokeState
    }
    
    public func setName(name: String) {
        self.name = name
    }
    public func getName() -> String {
        return name ?? ""
    }
    public func getFamilyCode() -> String {
        return familyCode ?? ""
    }
    public func setToolImage(toolImage: UIImage) {
        self.toolImage = toolImage
    }
    public func getToolImage() -> UIImage {
        return toolImage ?? UIImage()
    }
    public func getToolType() -> String {
        return toolType ?? ""
    }
    public func setToolType(with tool: String) {
        self.toolType = tool
    }
    public func getToolColor() -> String {
        return toolColor ?? ""
    }
    public func setToolColor(with color: String) {
        self.toolColor = color
    }
    public func setFamilyCode(code: String) {
        self.familyCode = code
    }
    public func setPoke(poke: Poke) {
        self.pokeState = poke
    }
}

// setToolColor(with: "Yellow")
