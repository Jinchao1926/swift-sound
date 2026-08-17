//
//  TopPlaylistsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

/// API returned `tracks` could be null; call detail API for full response.
struct PlaylistCategoriesResponse: nonisolated Decodable {
    let all: PlaylistCategory
    let sub: [PlaylistCategory]
    let categories: [String: String]
    let code: Int
}

struct PlaylistCategoriesRequest: APIRequest {
    typealias Response = PlaylistCategoriesResponse

    let path = "/playlist/catlist"
    let cachePolicy: APICachePolicy = .memory(ttl: 300)
}
