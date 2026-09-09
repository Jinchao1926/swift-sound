//
//  RadioCategory+Preview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import Foundation

#if DEBUG
extension RadioCategory {
    static let preview = RadioCategory(id: 2, name: "音乐播客", picWebUrl: "")
}

extension Array where Element == RadioCategory {
    static let preview: [RadioCategory] = [
        RadioCategory(id: 3, name: "情感", picWebUrl: ""),
        RadioCategory(id: 2, name: "音乐播客", picWebUrl: ""),
        RadioCategory(id: 10001, name: "有声书", picWebUrl: ""),
        RadioCategory(id: 8, name: "脱口秀", picWebUrl: ""),
        RadioCategory(id: 2001, name: "创作翻唱", picWebUrl: ""),
        RadioCategory(id: 10002, name: "电音", picWebUrl: ""),
        RadioCategory(id: 11, name: "知识", picWebUrl: ""),
        RadioCategory(id: 3001, name: "二次元", picWebUrl: ""),
        RadioCategory(id: 14, name: "明星专区", picWebUrl: ""),
        RadioCategory(id: 6, name: "生活", picWebUrl: ""),
        RadioCategory(id: 13, name: "亲子", picWebUrl: ""),
        RadioCategory(id: 3087096, name: "资讯", picWebUrl: ""),
        RadioCategory(id: 3088097, name: "广播剧", picWebUrl: ""),
        RadioCategory(id: 3080097, name: "故事", picWebUrl: ""),
        RadioCategory(id: 3080098, name: "人文历史", picWebUrl: ""),
        RadioCategory(id: 3083097, name: "娱乐", picWebUrl: ""),
        RadioCategory(id: 3088098, name: "相声曲艺", picWebUrl: ""),
        RadioCategory(id: 3081098, name: "其他", picWebUrl: ""),
        RadioCategory(id: 3148096, name: "文学出版", picWebUrl: "")
    ]
}
#endif
