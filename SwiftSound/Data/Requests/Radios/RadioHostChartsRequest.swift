//
//  RadioHostChartsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

struct RadioHostCharts: Decodable {
    let total: Int
    let updateTime: Int
    let list: [RadioHost]
}

struct RadioHostChartsResponse: nonisolated Decodable {
    let data: RadioHostCharts
    let code: Int
}

// 24 小时主播榜
struct RadioHostChartsDailyRequest: APIRequest {
    typealias Response = RadioHostChartsResponse

    let path = "/dj/toplist/hours"
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)
}

// 主播新人榜
struct RadioHostChartsNewComerRequest: APIRequest {
    typealias Response = RadioHostChartsResponse

    let path = "/dj/toplist/newcomer"
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)
}

// 最热主播榜
struct RadioHostChartsPopularRequest: APIRequest {
    typealias Response = RadioHostChartsResponse

    let path = "/dj/toplist/popular"
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)
}
