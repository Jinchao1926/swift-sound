//
//  MVURLRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/5.
//

import Foundation

struct MVURLResponse: nonisolated Decodable {
    let data: MVURL
    let code: Int
}

/**
 * mv 地址
 * 说明 : 调用此接口 , 传入 mv id,可获取 mv 播放地址
 * 必选参数 : `id`: mv id
 * 可选参数 : `r`: 分辨率,默认 1080,可从 `/mv/detail` 接口获取分辨率列表
 */
struct MVURLRequest: APIRequest {
    typealias Response = MVURLResponse

    let path = "/mv/url"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int, r: Int? = nil) {
        var items = [URLQueryItem(name: "id", value: String(id))]

        if let r {
            items.append(URLQueryItem(name: "r", value: String(r)))
        }

        self.queryItems = items
    }
}
