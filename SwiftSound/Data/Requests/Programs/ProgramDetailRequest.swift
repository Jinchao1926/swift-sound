//
//  ProgramDetailRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation

struct ProgramDetailResponse: nonisolated Decodable {
    let program: Program
    let code: Int
}

struct ProgramDetailRequest: APIRequest {
    typealias Response = ProgramDetailResponse

    let path = "/dj/program/detail"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
    }
}
