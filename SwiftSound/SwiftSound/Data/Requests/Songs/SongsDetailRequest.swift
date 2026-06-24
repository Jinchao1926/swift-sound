//
//  SongsDetailRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/24.
//

import Foundation

struct SongsDetailResponse: nonisolated Decodable {
    let songs: [Song]
    let code: Int
}

struct SongsDetailRequest: APIRequest {
    typealias Response = SongsDetailResponse

    let path = "/song/detail"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "ids", value: String(id))
        ]
    }

    init(ids: [Int]) {
        self.queryItems = [
            URLQueryItem(name: "ids", value: ids.map(String.init).joined(separator: ","))
        ]
    }
}
