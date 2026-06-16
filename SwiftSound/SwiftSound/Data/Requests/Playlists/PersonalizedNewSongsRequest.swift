//
//  NewSongRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation

struct PersonalizedNewSongsResponse: nonisolated Decodable {
    let result: [NewSong]
    let code: Int
    let category: Int
}

struct PersonalizedNewSongsRequest: APIRequest {
    typealias Response = PersonalizedNewSongsResponse

    let path = "/personalized/newsong"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: 300)

    init(offset: Int = 0, limit: Int = 12) {
        self.queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}
