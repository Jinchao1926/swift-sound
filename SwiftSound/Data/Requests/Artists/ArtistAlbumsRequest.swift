//
//  ArtistAlbumsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/31.
//

import Foundation

struct ArtistAlbumsResponse: nonisolated Decodable {
    let hotAlbums: [Album]
    let artist: Artist
    let more: Bool
    let total: Int?
    let code: Int
}

extension ArtistAlbumsResponse: PaginatedResponse {
    var items: [Album] { hotAlbums }
    var canLoadMore: Bool { more }
}

struct ArtistAlbumsRequest: APIRequest {
    typealias Response = ArtistAlbumsResponse

    let path = "/artist/album"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(
        id: Int,
        offset: Int?,
        limit: Int?
    ) {
        let offset = offset ?? 0
        let limit = limit ?? 40
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}
