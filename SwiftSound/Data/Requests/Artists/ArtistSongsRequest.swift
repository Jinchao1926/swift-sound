//
//  ArtistSongsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/31.
//

import Foundation

struct ArtistSongsResponse: nonisolated Decodable {
    let songs: [Song]
    let more: Bool
    let total: Int
    let code: Int
}

extension ArtistSongsResponse: PaginatedResponse {
    var items: [Song] { songs }
    var canLoadMore: Bool { more }
}

struct ArtistSongsRequest: APIRequest {
    typealias Response = ArtistSongsResponse

    let path = "/artist/songs"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(
        id: Int,
        offset: Int?,
        limit: Int?
    ) {
        let offset = offset ?? 0
        let limit = limit ?? 50
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}
