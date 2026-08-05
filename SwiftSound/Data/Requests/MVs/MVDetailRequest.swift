//
//  MVDetailRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/5.
//

import Foundation

struct MVDetailResponse: nonisolated Decodable {
    let data: MVDetail
    let code: Int
}

struct MVDetailRequest: APIRequest {
    typealias Response = MVDetailResponse

    let path = "/mv/detail"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "mvid", value: String(id))
        ]
    }
}
