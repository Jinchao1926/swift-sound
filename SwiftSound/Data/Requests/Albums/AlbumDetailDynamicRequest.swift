//
//  AlbumDetailDynamicRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/3.
//

import Foundation

struct AlbumDetailDynamicResponse: nonisolated Decodable {
    let code: Int
    let dynamic: AlbumDetailDynamic

    enum CodingKeys: String, CodingKey {
        case code
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        dynamic = try AlbumDetailDynamic(from: decoder)
    }
}

struct AlbumDetailDynamicRequest: APIRequest {
    typealias Response = AlbumDetailDynamicResponse

    let path = "/album/detail/dynamic"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
    }
}
