//
//  User.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

/**
{
     "defaultAvatar": false,
     "province": 330000,
     "authStatus": 1,
     "followed": false,
     "avatarUrl": "http://p1.music.126.net/eHeoKe-NWVBMM8S3DCJfog==/109951163951118282.jpg",
     "accountStatus": 0,
     "gender": 2,
     "city": 330100,
     "birthday": 1551456000000,
     "userId": 1463586082,
     "userType": 10,
     "nickname": "云音乐官方歌单",
     "signature": "精选好歌，非听不可！",
     "description": "网易云音乐官方歌单",
     "detailDescription": "网易云音乐官方歌单",
     "avatarImgId": 109951163951118290,
     "backgroundImgId": 109951165404950140,
     "backgroundUrl": "http://p1.music.126.net/chlOFsm3eMrJGc4b9am18A==/109951165404950147.jpg",
     "authority": 0,
     "mutual": false,
     "expertTags": null,
     "experts": null,
     "djStatus": 0,
     "vipType": 11,
     "remarkName": null,
     "authenticationTypes": 2048,
     "avatarDetail": {
         "userType": 10,
         "identityLevel": 1,
         "identityIconUrl": "https://p5.music.126.net/obj/wo3DlcOGw6DClTvDisK1/4788940880/1a1f/68f5/b59a/b444b81b88567108ba88194fa29144f5.png"
     },
     "avatarImgIdStr": "109951163951118282",
     "backgroundImgIdStr": "109951165404950147",
     "anchor": false
 },
 */

enum Gender: Int, Decodable {
    case unknow = 0
    case male
    case female
}

struct AvatarDetail: Decodable {
    let identityLevel: Int
    let identityIconUrl: String
}

struct Identify: Decodable {
    let imageUrl: String
    let imageDesc: String
}

struct User: Decodable, Identifiable {
    let userId: Int
    let nickname: String
    let gender: Gender
    let avatarUrl: String
    let avatarDetail: AvatarDetail?
    let description: String?
    let signature: String?
    let vipType: Int
    let province: Int
    let city: Int
    let followeds: Int?
    let follows: Int?
    let playlistCount: Int?
    let artistId: Int?

    var id: Int { userId }
}

extension User {
    var avatarURL: URL? { URL(string: avatarUrl) }
    var safeSignature: String {
        guard let signature, !signature.isEmpty else {
            return "这个用户很懒，什么都没留下"
        }
        return signature
    }

    var isVIP: Bool { vipType > 0 }
}
