//
//  ArtistListRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/22.
//

import Foundation

struct ArtistListResponse: nonisolated Decodable {
    let artists: [Artist]
    let code: Int
    let more: Bool
}

/**
 * 歌手分类列表
 * 说明 : 调用此接口,可获取歌手分类列表
 * 可选参数 :
 *  `limit` : 返回数量 , 默认为 30
 *  `offset` : 偏移数量，用于分页, 如 :( 页数 -1)\*30, 其中 30 为 limit 的值, 默认为 0
 *  `initial`: 按首字母索引查找参数,如 `/artist/list?type=1&area=96&initial=b`
 *             返回内容将以 name 字段开头为 b 或者拼音开头为 b 为顺序排列, 热门传-1,#传 0
 *  `type` 取值:
 *        ```
          -1:全部
          1:男歌手
          2:女歌手
          3:乐队
          ```
 *  `area` 取值:
          ```
          -1:全部
          7华语
          96欧美
          8:日本
          16韩国
          0:其他
          ```
 */

enum ArtistType: Int {
    case all = -1   // 全部
    case male = 1   // 男歌手
    case female = 2 // 女歌手
    case group = 3  // 乐队
}

enum ArtistArea: Int {
    case all = -1       // 全部
    case chinese = 7    // 华语
    case western = 96   // 欧美
    case japanese = 8   // 日本
    case korean = 16    // 韩国
    case other = 0      // 其他
}

struct ArtistListRequest: APIRequest {
    typealias Response = ArtistListResponse

    let path = "/artist/list"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(
        type: ArtistType,
        area: ArtistArea,
        offset: Int?,
        limit: Int?,
        initial: Int?
    ) {
        let offset = offset ?? 0
        let limit = limit ?? 40
        let initial = initial ?? -1
        self.queryItems = [
            URLQueryItem(name: "type", value: String(type.rawValue)),
            URLQueryItem(name: "area", value: String(area.rawValue)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "initial", value: String(initial))
        ]
    }
}
