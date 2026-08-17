//
//  PlaylistCategoryParser.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/14.
//

import Foundation

struct PlaylistCategoryGroup: Identifiable {
    let id: Int
    let name: String
    let subs: [PlaylistCategory]
}

// 只提供静态解析方法，不需要创建实例，所以用 enum 作为命名空间，避免无意义的初始化
enum PlaylistCategoryParser {
    static func parse(_ response: PlaylistCategoriesResponse) -> [PlaylistCategoryGroup] {
        response.categories
            .compactMap { key, name in
                guard let id = Int(key) else { return nil }

                let subs = response.sub.filter { $0.category == id }
                return PlaylistCategoryGroup(id: id, name: name, subs: subs)
            }
            .sorted { $0.id < $1.id }
    }
}
