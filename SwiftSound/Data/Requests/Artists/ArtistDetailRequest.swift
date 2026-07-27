//
//  PlaylistDetailRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

struct ArtistDetailResponse: nonisolated Decodable {
    let data: ArtistDetail
    let code: Int
}

struct ArtistDetailRequest: APIRequest {
    typealias Response = ArtistDetailResponse

    let path = "/artist/detail"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
    }
}
