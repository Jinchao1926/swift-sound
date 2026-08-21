//
//  TopSongsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/21.
//

import Foundation

enum TopSongsType: Int, CaseIterable {
    case all = 0
    case chinese = 7
    case western = 96
    case japanese = 8
    case korean = 16
}

extension TopSongsType: Identifiable {
    var id: Int { self.rawValue }

    var title: String {
        switch self {
        case .all:
            "全部"
        case .chinese:
            "华语"
        case .western:
            "欧美"
        case .japanese:
            "日本"
        case .korean:
            "韩国"
        }
    }
}

struct TopSongsResponse: nonisolated Decodable {
    let data: [Song]
    let code: Int
}

// 新歌速递，type: 0 全部，7 华语，96 欧美，8 日本，16 韩国
struct TopSongsRequest: APIRequest {
    typealias Response = TopSongsResponse

    let path = "/top/song"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: 300)

    init(type: TopSongsType = .all) {
        self.queryItems = [
            URLQueryItem(name: "type", value: String(type.rawValue))
        ]
    }
}
