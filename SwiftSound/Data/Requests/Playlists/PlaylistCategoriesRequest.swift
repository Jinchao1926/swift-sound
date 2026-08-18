//
//  TopPlaylistsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

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
