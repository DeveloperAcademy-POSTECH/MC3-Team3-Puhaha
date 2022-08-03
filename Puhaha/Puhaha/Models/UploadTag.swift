//
//  UploadTag.swift
//  Puhaha
//
//  Created by Lena on 2022/07/25.
//

import Foundation

struct UploadTag {
    var tagTitleName: String
    var tagContents: [Tag] = [Tag]()
}

struct UploadInformation {
    var tags: [Int]
    var mealImageIndex: Int
    var uploadUser: String
    var uploadedDate: String
    var uploadedTime: String
}

#if DEBUG
extension UploadTag {
    static let uploadTags = [
        UploadTag(tagTitleName: "시간",
                  tagContents: [Tag(content: "아침", backgroundColor: .customPurple),
                                Tag(content: "아점", backgroundColor: .customPurple),
                                Tag(content: "점심", backgroundColor: .customPurple),
                                Tag(content: "점저", backgroundColor: .customPurple),
                                Tag(content: "저녁", backgroundColor: .customPurple),
                                Tag(content: "야식", backgroundColor: .customPurple)]),
        UploadTag(tagTitleName: "메뉴",
                  tagContents: [Tag(content: "한식", backgroundColor: .customBlue),
                                Tag(content: "중식", backgroundColor: .customBlue),
                                Tag(content: "일식", backgroundColor: .customBlue),
                                Tag(content: "디저트", backgroundColor: .customBlue),
                                Tag(content: "양식", backgroundColor: .customBlue)]),
        UploadTag(tagTitleName: "기분",
                  tagContents: [Tag(content: "꿀맛", backgroundColor: .customGreen),
                                Tag(content: "최고에요", backgroundColor: .customGreen),
                                Tag(content: "별로에요", backgroundColor: .customGreen),
                                Tag(content: "맛없엉", backgroundColor: .customGreen)])
    ]
}
#endif
