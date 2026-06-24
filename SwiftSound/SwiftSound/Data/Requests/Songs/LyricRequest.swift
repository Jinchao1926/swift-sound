//
//  LyricRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/24.
//

import Foundation

struct SongLyricApiResponse: nonisolated Decodable {
    let lrc: Lyric
    let klyric: Lyric
    let tlyric: Lyric
    let romalrc: Lyric  // 粤语歌词
    let code: Int
}

struct LyricRequest: APIRequest {
    typealias Response = SongLyricApiResponse

    let path = "/lyric"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
    }
}
