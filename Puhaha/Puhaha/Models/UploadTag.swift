//
//  UploadTag.swift
//  Puhaha
//
//  Created by Lena on 2022/07/25.
//

import Foundation

struct UploadTag {
    var tagTitleName: String
    var tagContents: [String] = [String]()
}

#if DEBUG
extension UploadTag {
    static var uploadTags = [
        UploadTag(tagTitleName: "시간",
                  tagContents: ["아침", "아점", "점심", "점저", "저녁", "야식"]),
        UploadTag(tagTitleName: "메뉴",
                  tagContents: ["한식", "중식", "일식", "디저트", "양식"]),
        UploadTag(tagTitleName: "기분",
                  tagContents: ["꿀맛", "최고에요", "별로에요", "맛없엉"])
        ]
}
#endif
