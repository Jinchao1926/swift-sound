//
//  RadioChartsPaidRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/10.
//

import Foundation

struct RadioPaidCharts: Decodable {
    let total: Int
    let updateTime: Int
    let list: [RadioPaidChart]
}

struct RadioChartsPaidResponse: nonisolated Decodable {
    let data: RadioPaidCharts
    let code: Int
}

struct RadioChartsPaidRequest: APIRequest {
    typealias Response = RadioChartsPaidResponse

    let path = "/dj/toplist/pay"
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)
}
