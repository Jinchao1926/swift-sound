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
    var canLoadMore: Bool { more }
}

struct FeaturedPlaylistsRequest: APIRequest {
    typealias Response = FeaturedPlaylistsResponse

    let path = "/top/playlist/highquality"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: 300)

    init(category: String, offset: Int = 0, limit: Int = 24) {
        self.queryItems = [
            URLQueryItem(name: "cat", value: category),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}
