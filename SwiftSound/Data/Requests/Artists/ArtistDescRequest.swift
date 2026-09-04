//
//  ArtistDescRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/28.
//

import Foundation

struct ArtistDesc {
    let introduction: [ArtistIntroduction]
    let briefDesc: String

    init(introduction: [ArtistIntroduction], briefDesc: String) {
        self.introduction = introduction
        self.briefDesc = briefDesc
    }

    init(response: ArtistDescResponse) {
        self.introduction = response.introduction
        self.briefDesc = response.briefDesc
    }
}

extension ArtistDesc: LoadableValue {
    var isEmpty: Bool {
        briefDesc.isEmpty && introduction.isEmpty
    }
}

struct ArtistDescResponse: nonisolated Decodable {
    let introduction: [ArtistIntroduction]
    let briefDesc: String
    let code: Int
}

struct ArtistDescRequest: APIRequest {
    typealias Response = ArtistDescResponse

    let path = "/artist/desc"
    let queryItems: [URLQueryItem]
    let cachePolicy: APICachePolicy = .memory(ttl: .infinity)

    init(id: Int) {
        self.queryItems = [
            URLQueryItem(name: "id", value: String(id))
        ]
    }
}
