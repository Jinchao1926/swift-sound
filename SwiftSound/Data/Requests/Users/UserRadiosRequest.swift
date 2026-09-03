//
//  UserRadiosRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

struct UserRadiosResponse: nonisolated Decodable {
    let djRadios: [Radio]
    let hasMore: Bool
    let count: Int
    let code: Int
}

extension UserRadiosResponse: PaginatedResponse {
    var items: [Radio] { djRadios }
    var canLoadMore: Bool { hasMore }
}

struct UserRadiosRequest: APIRequest {
    typealias Response = UserRadiosResponse

    let path = "/user/audio"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: 300)

    init(uid: Int) {
        self.queryItems = [
            URLQueryItem(name: "uid", value: String(uid))
        ]
    }
}
