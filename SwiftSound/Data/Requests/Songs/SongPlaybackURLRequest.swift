//
//  SongPlaybackURLRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/26.
//

import Foundation

struct SongPlaybackURLResponse: nonisolated Decodable {
    let data: [SongPlaybackURL]
    let code: Int
}

struct SongPlaybackURLRequest: APIRequest {
    typealias Response = SongPlaybackURLResponse

    let path = "/song/url/v1"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: 1200)

    init(id: Int, level: SongPlaybackQuality = .standard) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id)),
            URLQueryItem(name: "level", value: level.rawValue)
        ]
    }
}
