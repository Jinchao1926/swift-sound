//
//  RadioDetailRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation

struct RadioDetailResponse: nonisolated Decodable {
    let data: Radio
    let code: Int
}

struct RadioDetailRequest: APIRequest {
    typealias Response = RadioDetailResponse

    let path = "/dj/detail"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "rid", value: String(id))
        ]
    }
}
