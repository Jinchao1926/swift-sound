//
//  FeaturedPlaylistsResponse.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/18.
//

import Foundation

struct FeaturedPlaylistsResponse: nonisolated Decodable {
    let playlists: [Playlist]
    let more: Bool
    let lasttime: Int
    let total: Int
    let code: Int
}

extension FeaturedPlaylistsResponse: PaginatedResponse {
    var items: [Playlist] { playlists }
    var canLoadMore: Bool { more && !playlists.isEmpty }
}

/**
 获取精品歌单
 说明 : 调用此接口 , 可获取精品歌单
 
 可选参数:
 `cat`: tag, 比如 "华语"、"古风"、"欧美"、"流行", 默认为“全部"，可从精品歌单标签列表接口获取(`/playlist/highquality/tags`)
 `limit`: 取出歌单数量 , 默认为 50
 `before`: 分页参数，取上一页最后一个歌单的 `updateTime` 获取下一页数据
 */
struct FeaturedPlaylistsRequest: APIRequest {
    typealias Response = FeaturedPlaylistsResponse

    let path = "/top/playlist/highquality"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: 300)

    init(category: String?, before: Int? = nil, limit: Int = 24) {
        var queryItems = [
            URLQueryItem(name: "limit", value: String(limit))
        ]

        if let category {
            queryItems.append(.init(name: "cat", value: category))
        }
        if let before {
            queryItems.append(.init(name: "before", value: String(before)))
        }
        self.queryItems = queryItems
    }
}
