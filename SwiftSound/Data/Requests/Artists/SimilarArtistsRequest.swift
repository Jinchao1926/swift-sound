//
//  SimilarArtistsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/28.
//

import Foundation

struct SimilarArtistsResponse: nonisolated Decodable {
    let code: Int
}

struct SimilarArtistsRequest: APIRequest {
    typealias Response = ArtistDescResponse

    let path = "/artist/desc"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
    }
}
