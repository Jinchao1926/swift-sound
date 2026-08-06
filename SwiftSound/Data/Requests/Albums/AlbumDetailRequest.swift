//
//  AlbumDetailRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/3.
//

import Foundation

typealias AlbumDetail = AlbumDetailResponse
struct AlbumDetailResponse: nonisolated Decodable {
    let songs: [Song]
    let album: Album
    let code: Int
}

struct AlbumDetailRequest: APIRequest {
    typealias Response = AlbumDetailResponse

    let path = "/album"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        debugPrint("AlbumDetailRequest: \(id)")
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
    }
}
