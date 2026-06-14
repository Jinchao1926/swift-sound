//
//  BannersRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation

struct BannersResponse: Decodable {
    let banners: [Banner]
    let code: Int
}

struct BannersRequest: APIRequest {
    typealias Response = BannersResponse

    let path = "/banner"
    let cachePolicy: APICachePolicy = .memory(ttl: 300)
}
