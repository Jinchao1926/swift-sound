//
//  PlaylistDetailRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

struct PlaylistDetailResponse: nonisolated Decodable {
    let playlist: Playlist
    let code: Int
}

struct PlaylistDetailRequest: APIRequest {
    typealias Response = PlaylistDetailResponse

    let path = "/playlist/detail"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
    }
}
