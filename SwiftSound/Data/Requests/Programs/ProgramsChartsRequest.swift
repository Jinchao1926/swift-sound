//
//  ProgramsChartsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation

struct ProgramsChartsResponse: nonisolated Decodable {
    let updateTime: Int
    let toplist: [ProgramChart]
    let code: Int
}

struct ProgramsChartsRequest: APIRequest {
    typealias Response = ProgramsChartsResponse

    let path = "/dj/program/toplist"
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)
}
