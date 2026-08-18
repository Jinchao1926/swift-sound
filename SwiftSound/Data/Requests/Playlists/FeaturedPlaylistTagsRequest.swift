//
//  FeaturedPlaylistTagsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/18.
//

import Foundation

struct FeaturedPlaylistTagsResponse: nonisolated Decodable {
    let tags: [FeaturedPlaylistTag]
    let code: Int
}

struct FeaturedPlaylistTagsRequest: APIRequest {
    typealias Response = FeaturedPlaylistTagsResponse

    let path = "/playlist/highquality/tags"
    let cachePolicy: APICachePolicy = .memory(ttl: 300)
}
