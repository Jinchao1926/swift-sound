//
//  RadioProgramsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation

struct RadioProgramsResponse: nonisolated Decodable {
    let programs: [Program]
    let count: Int
    let more: Bool
    let code: Int
}

extension RadioProgramsResponse: PaginatedResponse {
    var items: [Program] { programs }
    var canLoadMore: Bool { more }
}

/**
 * 电台 - 节目
 * 说明 : 传入`rid`, 可查看对应电台的电台节
 * 必选参数 : `rid`: 电台 的 id
 * 可选参数 :
 *  `limit` : 返回数量 , 默认为 100
 *  `offset` : 偏移数量，用于分页 , 如 :( 页数 -1)\*100, 其中 100 为 limit 的值 , 默认为 0
 *  `asc` : 排序方式,默认为 `false` (新 => 老 ) 设置 `true` 可改为 老 => 新
 */
struct RadioProgramsRequest: APIRequest {
    typealias Response = RadioProgramsResponse

    let path = "/dj/program"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(
        id: Int,
        offset: Int?,
        limit: Int?,
        asc: Bool = false
    ) {
        let offset = offset ?? 0
        let limit = limit ?? 100
        self.queryItems = [
            URLQueryItem(name: "rid", value: String(id)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "asc", value: String(asc))
        ]
    }
}
