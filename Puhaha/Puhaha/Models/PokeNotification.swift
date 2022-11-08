//
//  PokeNotification.swift
//  Puhaha
//
//  Created by JiwKang on 2022/11/08.
//

struct PokeNotification: Codable {
    let to: String
    let notification: PokeNotificationData
}

struct PokeNotificationData: Codable {
    let body: String
}
