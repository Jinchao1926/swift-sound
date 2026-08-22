//
//  TopAlbumsRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/21.
//

import Foundation

enum TopAlbumsArea: String, CaseIterable {
    case all = "ALL"
    case chinese = "ZH"
    case western = "EA"
    case korean = "KR"
    case japanese = "JP"
}

extension TopAlbumsArea: Identifiable {
    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .all:
            "全部"
        case .chinese:
            "华语"
        case .western:
            "欧美"
        case .korean:
            "韩国"
        case .japanese:
            "日本"
        }
    }
}

enum TopAlbumsType: String, CaseIterable {
    case new
    case hot
}

extension TopAlbumsType: Identifiable {
    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .new:
            "全部"
        case .hot:
            "推荐"
        }
    }
}

typealias TopAlbums = TopAlbumsResponse
struct TopAlbumsResponse: nonisolated Decodable {
    let weekData: [Album]?
    let monthData: [Album]
    let code: Int
}

/**
 新碟上架

 `area`: ALL:全部,ZH:华语,EA:欧美,KR:韩国,JP:日本
 `type`: new:全部 hot:热门,默认为 new
 `year`: 年,默认本年
 `month`: 月,默认本月
 调用例子: `/top/album?offset=0&limit=30&year=2019&month=6`
 */
struct TopAlbumsRequest: APIRequest {
    typealias Response = TopAlbumsResponse

    let path = "/top/album"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: 300)

    init(
        area: TopAlbumsArea = .all,
        type: TopAlbumsType = .new,
        year: Int? = nil,
        month: Int? = nil
    ) {
        var queryItems = [
            URLQueryItem(name: "area", value: area.rawValue),
            URLQueryItem(name: "type", value: type.rawValue)
        ]

        if let year {
            queryItems.append(URLQueryItem(name: "year", value: String(year)))
        }
        if let month {
            queryItems.append(URLQueryItem(name: "month", value: String(month)))
        }

        self.queryItems = queryItems
    }
}
