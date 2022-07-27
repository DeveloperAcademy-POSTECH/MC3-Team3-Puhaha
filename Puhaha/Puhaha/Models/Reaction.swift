//
//  Reaction.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/23.
//

import UIKit

struct Reaction {
    var reactionEmojiImage: UIImage
    var reactionEmojiString: String
    var reactedUserName: String
}

#if DEBUG
extension Reaction {
    static let sampleReaction: [Reaction?] = [
        nil,
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "😆", reactedUserName: "콜리"),
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "🤣", reactedUserName: "키"),
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "😇", reactedUserName: "레나"),
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "😛", reactedUserName: "티모"),
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "🤩", reactedUserName: "우기"),
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "😆", reactedUserName: "콜리"),
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "🤣", reactedUserName: "키"),
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "😇", reactedUserName: "레나"),
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "😛", reactedUserName: "티모"),
        Reaction(reactionEmojiImage: UIImage(systemName: "hand.thumbsup.circle")!, reactionEmojiString: "🤩", reactedUserName: "우기")
    ]
}
#endif
