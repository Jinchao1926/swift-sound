//
//  ArtistMVsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/3.
//

import Foundation

struct ArtistMVsResponse: nonisolated Decodable {
    let mvs: [MV]
    let hasMore: Bool
    let code: Int
}

extension ArtistMVsResponse: PaginatedResponse {
    var items: [MV] { mvs }
    var canLoadMore: Bool { hasMore }
}

struct ArtistMVsRequest: APIRequest {
    typealias Response = ArtistMVsResponse

    let path = "/artist/mv"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(
        id: Int,
        offset: Int?,
        limit: Int?
    ) {
        let offset = offset ?? 0
        let limit = limit ?? 18
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}
