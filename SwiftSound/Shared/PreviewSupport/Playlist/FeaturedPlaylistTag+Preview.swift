//
//  FeaturedPlaylistTag+Preview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/19.
//

import Foundation

#if DEBUG
extension FeaturedPlaylistTag {
    static let preview = makeFeaturedPlaylistTag(id: 5001, name: "华语", type: 0)
    static let preview1 = makeFeaturedPlaylistTag(id: 1045, name: "欧美", type: 1)
    static let preview2 = makeFeaturedPlaylistTag(id: 5003, name: "韩语", type: 1)
    static let preview3 = makeFeaturedPlaylistTag(id: 5002, name: "日语", type: 1)
    static let preview4 = makeFeaturedPlaylistTag(id: 2040, name: "粤语", type: 1)
    static let preview5 = makeFeaturedPlaylistTag(id: 10001, name: "另类/独立", type: 0)
    static let preview6 = makeFeaturedPlaylistTag(id: 5005, name: "R&B/Soul", type: 1)

    static func makeFeaturedPlaylistTag(
        id: Int,
        name: String,
        type: Int
    ) -> FeaturedPlaylistTag {
        FeaturedPlaylistTag(id: id, name: name, type: type, category: 0, hot: false)
    }
}

extension Array where Element == FeaturedPlaylistTag {
    static let preview = [
        FeaturedPlaylistTag.preview1,
        FeaturedPlaylistTag.preview2,
        FeaturedPlaylistTag.preview3,
        FeaturedPlaylistTag.preview4,
        FeaturedPlaylistTag.preview5,
        FeaturedPlaylistTag.preview6
    ]
}

#endif
