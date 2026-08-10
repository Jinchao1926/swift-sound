//
//  ToplistsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import Foundation

struct ToplistsResponse: nonisolated Decodable {
    let list: [Toplist]
    let code: Int
}

struct ToplistsRequest: APIRequest {
    typealias Response = ToplistsResponse

    let path = "/toplist"
    let cachePolicy: APICachePolicy = .memory(ttl: 300)
}

struct ToplistDetailsRequest: APIRequest {
    typealias Response = ToplistsResponse

    let path = "/toplist/detail"
    let cachePolicy: APICachePolicy = .memory(ttl: 300)
}
