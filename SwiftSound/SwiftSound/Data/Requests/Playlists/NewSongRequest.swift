//
//  NewSongRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation

struct NewSongResponse: nonisolated Decodable {
    let result: [NewSong]
    let code: Int
    let category: Int
}

struct NewSongRequest: APIRequest {
    typealias Response = NewSongResponse

    let path = "/personalized/newsong"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: 300)

    init(category: String, offset: Int = 0, limit: Int = 12) {
        self.queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}
