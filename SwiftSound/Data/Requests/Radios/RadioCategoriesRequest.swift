//
//  RadioCategoriesRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import Foundation

struct RadioCategoriesResponse: nonisolated Decodable {
    let categories: [RadioCategory]
    let code: Int
}

struct RadioCategoriesRequest: APIRequest {
    typealias Response = RadioCategoriesResponse

    let path = "/dj/catelist"
    let cachePolicy: APICachePolicy = .memory(ttl: 300)
}
