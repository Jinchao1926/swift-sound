//
//  ProgramsChartsDailyRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation

struct ProgramsChartsDaily: Decodable {
    let list: [ProgramChart]
    let updateTime: Int
    let total: Int
}

struct ProgramsChartsDailyResponse: nonisolated Decodable {
    let data: ProgramsChartsDaily
    let code: Int
}

struct ProgramsChartsDailyRequest: APIRequest {
    typealias Response = ProgramsChartsDailyResponse

    let path = "/dj/program/toplist/hours"
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)
}
