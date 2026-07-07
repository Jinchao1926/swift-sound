//
//  TopPlaylistsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

/// API returned `tracks` could be null; call detail API for full response.
struct TopPlaylistsResponse: nonisolated Decodable {
    let playlists: [Playlist]
    let code: Int
    let total: Int
    let more: Bool
    let cat: String
}

struct TopPlaylistsRequest: APIRequest {
    typealias Response = TopPlaylistsResponse

    let path = "/top/playlist"
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
