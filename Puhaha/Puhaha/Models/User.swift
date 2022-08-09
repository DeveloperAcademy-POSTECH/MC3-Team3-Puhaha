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
    private var familyCode: String?
    private var pokeState: Poke?
    
    init() {
        self.accountId = nil
        self.name = nil
        self.loginForm = 0

        self.toolImage = nil
        self.familyCode = nil
        self.pokeState = nil
    }
    
    init(accountId: String) {
        self.accountId = accountId
        self.name = nil
        self.loginForm = 0

        self.toolImage = nil
        self.familyCode = nil
        self.pokeState = nil
    }
    
    init(accountId: String, name: String) {
        self.accountId = accountId
        self.name = name
        self.loginForm = 0

        self.toolImage = nil
        self.familyCode = nil
        self.pokeState = nil
    }
    
    init(accountId: String, name: String, loginForm: Int, toolImage: UIImage, familyCode: String, pokeState: Poke) {
        self.accountId = accountId
        self.name = name
        self.loginForm = loginForm

        self.toolImage = toolImage
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
    public func setFamilyCode(code: String) {
        self.familyCode = code
    }
    public func setPoke(poke: Poke) {
        self.pokeState = poke
    }
}
