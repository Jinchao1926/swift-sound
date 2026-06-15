//
//  Playlist.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

/**
 {
     "name": "全球流行趋势 | 黄丽玲,Olivia Rodrigo,米津玄师和更多好歌",
     "id": 8159674692,
     "trackNumberUpdateTime": 1781452800000,
     "status": 0,
     "userId": 1463586082,
     "createTime": 1676258610872,
     "updateTime": 1781493244538,
     "subscribedCount": 10479,
     "trackCount": 60,
     "cloudTrackCount": 0,
     "coverImgUrl": "http://p1.music.126.net/ibyMPCbHs4yEZJBbwvdYhw==/109951173388746184.jpg?imageView=1&thumbnail=800y800&enlarge=1%7CimageView=1&watermark&type=1&image=b2JqL3dvbkRsc0tVd3JMQ2xHakNtOEt4LzI3NjEwNDk3MDYyL2VlOTMvOTIxYS82NjE4LzdhMDc5ZDg0NTYyMDAwZmVkZWJmMjVjYjE4NjhkOWEzLnBuZw==&dx=0&dy=0%7CimageView=1&thumbnail=140y140&",
     "iconImgUrl": null,
     "coverImgId": 109951173388746180,
     "description": "Cover：黄丽玲A-Lin ;\n《一个人》跳脱过往华语抒情歌的框架，加入电子声响与合成器元素，带着一点复古、80 年代氛围，并隐隐带有日系City Pop与太鼓感的声音质地。歌曲在熟悉的旋律线条中，依然保留着现代感的声音表情，既能听见大家熟悉的Lin式情歌，却又和她过去的作品状态有着明显区隔。\n全球流行趋势收录时下热门的华语、欧美、日韩流行新单，欢迎收藏订阅~即刻锁定当下最in旋律！潮流全掌握！",
     "tags": [],
     "playCount": 6679959,
     "trackUpdateTime": 1781508787442,
     "specialType": 100,
     "totalDuration": 0,
     "creator": {
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
     "tracks": null,
     "subscribers": [
         {
             "defaultAvatar": false,
             "province": 440000,
             "authStatus": 0,
             "followed": false,
             "avatarUrl": "http://p1.music.126.net/pSJXCjeib56nc8Kt5o5x0A==/109951170388233951.jpg",
             "accountStatus": 0,
             "gender": 2,
             "city": 440100,
             "birthday": -2209017600000,
             "userId": 1608473691,
             "userType": 0,
             "nickname": "小仙丹吖",
             "signature": "",
             "description": "",
             "detailDescription": "",
             "avatarImgId": 109951170388233950,
             "backgroundImgId": 109951162868126480,
             "backgroundUrl": "http://p1.music.126.net/_f8R60U9mZ42sSNvdPn2sQ==/109951162868126486.jpg",
             "authority": 0,
             "mutual": false,
             "expertTags": null,
             "experts": null,
             "djStatus": 10,
             "vipType": 11,
             "remarkName": null,
             "authenticationTypes": 0,
             "avatarDetail": null,
             "avatarImgIdStr": "109951170388233951",
             "backgroundImgIdStr": "109951162868126486",
             "anchor": false
         }
     ],
     "subscribed": null,
     "commentThreadId": "A_PL_0_8159674692",
     "newImported": false,
     "adType": 0,
     "highQuality": false,
     "privacy": 0,
     "ordered": false,
     "anonimous": false,
     "coverStatus": 3,
     "recommendInfo": null,
     "socialPlaylistCover": null,
     "recommendText": null,
     "coverText": [],
     "relateResType": "",
     "relateResId": null,
     "tsSongCount": 0,
     "algType": null,
     "playlistType": "PGC",
     "uiPlaylistType": "PGC",
     "originalCoverId": 0,
     "backgroundImageId": 109951173388741840,
     "backgroundImageUrl": "http://p1.music.126.net/m4xYhJkOkqAbSQt-WY8c-g==/109951173388741846.jpg",
     "topTrackIds": null,
     "promptedMgcInfo": null,
     "title": "全球流行趋势",
     "subTitle": "黄丽玲,Olivia Rodrigo,米津玄师和更多好歌",
     "backgroundText": "全球流行趋势",
     "mix": false,
     "shareCount": 138,
     "coverImgId_str": "109951173388746184",
     "alg": "op_rcmd",
     "commentCount": 33
 },
 */

struct Playlist: Decodable {
    let id: Int
    let name: String
    let coverImgId: Int
    let coverImgUrl: String
    let createTime: Int
    let creator: User
    let description: String
    let tags: [String]
    let updateFrequency: String?
    let updateTime: Int
    let trackUpdateTime: Int
    let trackNumberUpdateTime: Int
    let tracks: [Track]?
    let trackCount: Int
    let playCount: Int
    let shareCount: Int
    let commentCount: Int
    let subscribedCount: Int
    let subscribers: [User]
}
