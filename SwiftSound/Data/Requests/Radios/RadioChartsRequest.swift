//
//  RadioChartsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Foundation

struct RadioChartsResponse: nonisolated Decodable {
    let toplist: [RadioChart]
    let updateTime: Int
    let code: Int
}

enum RadioChartsRequestType: String {
    case hot    // 热门电台榜
    case new    // 新晋电台榜
}

struct RadioChartsRequest: APIRequest {
    typealias Response = RadioChartsResponse

    let path = "/dj/toplist"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(type: RadioChartsRequestType) {
        self.queryItems = [
            URLQueryItem(name: "type", value: type.rawValue)
        ]
    }
}
