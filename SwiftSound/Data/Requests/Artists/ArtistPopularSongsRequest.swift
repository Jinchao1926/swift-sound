//
//  ArtistPopularSongsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/28.
//

import Foundation

struct ArtistPopularSongsResponse: nonisolated Decodable {
    let songs: [Song]
    let code: Int
}

struct ArtistPopularSongsRequest: APIRequest {
    typealias Response = ArtistPopularSongsResponse

    let path = "/artist/top/song"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
    }
}
