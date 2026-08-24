//
//  UserPlaylistsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

struct UserPlaylistsResponse: nonisolated Decodable {
    let playlist: [Playlist]
    let more: Bool
    let code: Int
}

extension UserPlaylistsResponse: PaginatedResponse {
    var items: [Playlist] { playlist }
    var canLoadMore: Bool { more }
}

struct UserPlaylistsRequest: APIRequest {
    typealias Response = UserPlaylistsResponse

    let path = "/user/playlist"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: 300)

    init(uid: Int, offset: Int = 0, limit: Int = 20) {
        self.queryItems = [
            URLQueryItem(name: "uid", value: String(uid)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}
