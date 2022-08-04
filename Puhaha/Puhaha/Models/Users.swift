//
//  User.swift
//  Puhaha
//
//  Created by 김소현 on 2022/07/31.
//

import UIKit

class Users {
    private var accountId: String?
    private var loginForm: Int?
    private var familyCode: String?
    
    private var name: String?
    private var toolImage: UIImage?
    private var pokeState: Poke?
    // 왜 옵셔널을 붙여야 할까? -> 그래야 nil이 할당 가능함
    
    init() {
        self.accountId = ""
        self.loginForm = 0
        self.familyCode = ""
        
        self.name = ""
        self.toolImage = nil
        self.pokeState = nil
    }
    
    init(accountId: String) {
        self.accountId = accountId
        self.loginForm = 0
        self.familyCode = ""
        
        self.name = ""
        self.toolImage = nil
        self.pokeState = nil
    }
    
    init(accountId: String, name: String) {
        self.accountId = accountId
        self.loginForm = 0
        self.familyCode = ""

        self.name = name
        self.toolImage = nil
        self.pokeState = nil
    }
    
    public func setName(name: String) {
        self.name = name
    }
    public func getName() -> String {
        return name ?? ""
    }
    public func setToolImage(toolImage: UIImage) {
        self.toolImage = toolImage
    }
    public func getToolImage() -> UIImage? {
        return toolImage ?? UIImage()
    }
    public func setFamilyCode(code: String) {
        self.familyCode = code
    }
    public func setPoke(poke: Poke) {
        self.pokeState = poke
    }
}
