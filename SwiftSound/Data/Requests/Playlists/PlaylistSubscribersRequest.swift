//
//  PlaylistSubscribersRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

struct PlaylistSubscribersResponse: nonisolated Decodable {
    let subscribers: [User]
    let total: Int
    let more: Bool
    let code: Int
}

extension PlaylistSubscribersResponse: PaginatedResponse {
    var items: [User] { subscribers }
    var canLoadMore: Bool { more }
}

struct PlaylistSubscribersRequest: APIRequest {
    typealias Response = PlaylistSubscribersResponse

    let path = "/playlist/subscribers"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int, offset: Int = 0, limit: Int = 24) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}
