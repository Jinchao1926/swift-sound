//
//  UserDetailRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import Foundation

typealias UserDetail = UserDetailResponse
struct UserDetailResponse: nonisolated Decodable {
    let identify: Identify?
    let profile: User
    let level: Int
    let listenSongs: Int
    let createTime: Int
    let createDays: Int
    let code: Int
}

struct UserDetailRequest: APIRequest {
    typealias Response = UserDetailResponse

    let path = "/user/detail"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(uid: Int) {
        self.queryItems = [
            URLQueryItem(name: "uid", value: String(uid))
        ]
    }
}
