//
//  Music.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

/**
{
    "name": "林俊杰",
    "id": 3684,
    "picId": 109951168529051970,
    "img1v1Id": 109951168529049970,
    "briefDesc": "",
    "picUrl": "http://p2.music.126.net/78q0jUUJ0h08GxAs2G-tCA==/109951168529051968.jpg",
    "img1v1Url": "http://p2.music.126.net/r6W-zCnV-aduVn_PLZYuYg==/109951168529049969.jpg",
    "albumSize": 70,
    "alias": [
    "JJ Lin",
    "Wayne Lim"
    ],
    "trans": "",
    "musicSize": 594,
    "topicPerson": 0,
    "showPrivateMsg": null,
    "isSubed": null,
    "accountId": null,
    "picId_str": "109951168529051968",
    "img1v1Id_str": "109951168529049969",
    "transNames": null,
    "followed": false,
    "mvSize": null,
    "publishTime": null,
    "identifyTag": null,
    "alg": null,
    "fansCount": null
}*/
/** 艺术家 */
struct Artist: Codable, Identifiable {
    let id: Int
    let accountId: Int? // user id
    let name: String
    let avatar: String?  // img1v1Url
    let cover: String?     // picUrl
    let albumSize: Int?
    let musicSize: Int?
    let mvSize: Int?
    let aliases: [String]
    let tns: [String]?

    init(
        id: Int,
        accountId: Int?,
        name: String,
        avatar: String?,
        cover: String?,
        albumSize: Int?,
        musicSize: Int?,
        mvSize: Int?,
        aliases: [String],
        tns: [String]?
    ) {
        self.id = id
        self.accountId = accountId
        self.name = name
        self.avatar = avatar
        self.cover = cover
        self.albumSize = albumSize
        self.musicSize = musicSize
        self.mvSize = mvSize
        self.aliases = aliases
        self.tns = tns
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case accountId
        case name
        case img1v1Url
        case avatar
        case picUrl
        case cover
        case albumSize
        case musicSize
        case mvSize
        case aliases
        case alias
        case tns
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        accountId = try container.decodeIfPresent(Int.self, forKey: .accountId)
        name = try container.decode(String.self, forKey: .name)
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
            ?? container.decodeIfPresent(String.self, forKey: .img1v1Url)
        cover = try container.decodeIfPresent(String.self, forKey: .cover)
            ?? container.decodeIfPresent(String.self, forKey: .picUrl)
        albumSize = try container.decodeIfPresent(Int.self, forKey: .albumSize)
        musicSize = try container.decodeIfPresent(Int.self, forKey: .musicSize)
        mvSize = try container.decodeIfPresent(Int.self, forKey: .mvSize)
        aliases = try container.decodeIfPresent([String].self, forKey: .aliases)
            ?? container.decodeIfPresent([String].self, forKey: .alias)
            ?? []
        tns = try container.decodeIfPresent([String].self, forKey: .tns)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(accountId, forKey: .accountId)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(avatar, forKey: .avatar)
        try container.encodeIfPresent(cover, forKey: .cover)
        try container.encodeIfPresent(albumSize, forKey: .albumSize)
        try container.encodeIfPresent(musicSize, forKey: .musicSize)
        try container.encodeIfPresent(mvSize, forKey: .mvSize)
        try container.encode(aliases, forKey: .aliases)
        try container.encodeIfPresent(tns, forKey: .tns)
    }
}

extension Artist {
    var avatarURL: URL? {
        guard let avatar else { return nil }
        return URL(string: avatar)
    }
}

struct ArtistIntroduction: Decodable {
    struct Introduction: Decodable {
        let ti: String
        let txt: String
    }

    let briefDesc: String
    let introduction: [Introduction]
}

// MARK: - ArtistDetail
struct ArtistDetail: Decodable {
    let artist: Artist
    let user: User?
}
