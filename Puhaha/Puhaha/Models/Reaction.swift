//
//  Reaction.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/23.
//

import UIKit

struct Reaction {
    var reactionEmojiString: String
    var reactedUserName: String
}

#if DEBUG
extension Reaction {
    static let sampleReaction: [Reaction?] = [
        nil,
        Reaction(reactionEmojiString: "😆", reactedUserName: "콜리"),
        Reaction(reactionEmojiString: "🤣", reactedUserName: "키"),
        Reaction(reactionEmojiString: "😇", reactedUserName: "레나"),
        Reaction(reactionEmojiString: "😛", reactedUserName: "티모"),
        Reaction(reactionEmojiString: "🤩", reactedUserName: "우기"),
        Reaction(reactionEmojiString: "😆", reactedUserName: "콜리"),
        Reaction(reactionEmojiString: "🤣", reactedUserName: "키"),
        Reaction(reactionEmojiString: "😇", reactedUserName: "레나"),
        Reaction(reactionEmojiString: "😛", reactedUserName: "티모"),
        Reaction(reactionEmojiString: "🤩", reactedUserName: "우기")
    ]
}
#endif
