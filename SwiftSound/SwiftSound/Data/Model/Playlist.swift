//
//  Playlist.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

/**
 {
     "name": "KPOP红心宝藏 | 高收藏率KPop仙曲推荐",
     "id": 13559051641,
     "trackNumberUpdateTime": 1778755150002,
     "status": 0,
     "userId": 8375377475,
     "createTime": 1744181608506,
     "updateTime": 1778755150002,
     "subscribedCount": 1019,
     "trackCount": 100,
     "cloudTrackCount": 0,
     "coverImgUrl": "http://p1.music.126.net/X0RTJfqDNaF4jDF_xa2avw==/109951173059753071.jpg?imageView=1&thumbnail=800y800&enlarge=1%7CimageView=1&watermark&type=1&image=b2JqL3c1bkRrTUtRd3JMRGpEekNtOE9tLzgwMjE1MDQ2MDE0LzYxYTEvMjAyNjQxNDE4MzgxMy94ODI0MTc3ODc1NTA5Mzk3MS5wbmc=&dx=0&dy=0%7Cwatermark&type=1&image=b2JqL3dvbkRsc0tVd3JMQ2xHakNtOEt4LzI3NjEwNDk3MDYyL2VlOTMvOTIxYS82NjE4LzdhMDc5ZDg0NTYyMDAwZmVkZWJmMjVjYjE4NjhkOWEzLnBuZw==&dx=0&dy=0%7CimageView=1&thumbnail=140y140&",
     "iconImgUrl": null,
     "coverImgId": 109951173059753070,
     "description": "一秒心动的K-Pop小众珍藏系列 好听的音乐压箱底就太可惜啦",
     "tags": [],
     "playCount": 558032,
     "trackUpdateTime": 1781531132112,
     "specialType": 100,
     "totalDuration": 0,
     "creator": {
         "defaultAvatar": false,
         "province": 330000,
         "authStatus": 1,
         "followed": false,
         "avatarUrl": "http://p1.music.126.net/R_drcxvByTc9PLny9frqsw==/109951168306933094.jpg",
         "accountStatus": 0,
         "gender": 2,
         "city": 330100,
         "birthday": 1675872000000,
         "userId": 8375377475,
         "userType": 10,
         "nickname": "云音乐KPOP星球",
         "signature": "呦罗本！搜索 KPOP 进入 Kpop 专区发现更多好音乐！",
         "description": "云音乐韩语歌曲速递",
         "detailDescription": "云音乐韩语歌曲速递",
         "avatarImgId": 109951168306933090,
         "backgroundImgId": 109951162868128400,
         "backgroundUrl": "http://p1.music.126.net/2zSNIqTcpHL2jIvU6hG0EA==/109951162868128395.jpg",
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
         "avatarImgIdStr": "109951168306933094",
         "backgroundImgIdStr": "109951162868128395",
         "anchor": false
     },
     "tracks": null,
     "subscribers": [
         {
             "defaultAvatar": false,
             "province": 530000,
             "authStatus": 0,
             "followed": false,
             "avatarUrl": "http://p1.music.126.net/hZbciEPPH-F1zqvbRKtY7Q==/109951173336233405.jpg",
             "accountStatus": 0,
             "gender": 1,
             "city": 530300,
             "birthday": 1031846400000,
             "userId": 1751972594,
             "userType": 0,
             "nickname": "听花海变调",
             "signature": "愿此行，终抵群星",
             "description": "",
             "detailDescription": "",
             "avatarImgId": 109951173336233400,
             "backgroundImgId": 109951165857213310,
             "backgroundUrl": "http://p1.music.126.net/nQopyUM5zJ202eq49WKHsg==/109951165857213318.jpg",
             "authority": 0,
             "mutual": false,
             "expertTags": null,
             "experts": null,
             "djStatus": 0,
             "vipType": 11,
             "remarkName": null,
             "authenticationTypes": 0,
             "avatarDetail": null,
             "avatarImgIdStr": "109951173336233405",
             "backgroundImgIdStr": "109951165857213318",
             "anchor": false
         }
     ],
     "subscribed": null,
     "commentThreadId": "A_PL_0_13559051641",
     "newImported": false,
     "adType": 0,
     "highQuality": false,
     "privacy": 0,
     "ordered": false,
     "anonimous": false,
     "coverStatus": 1,
     "recommendInfo": null,
     "socialPlaylistCover": null,
     "recommendText": null,
     "coverText": [
         "韩系❤️",
         "红心宝藏"
     ],
     "relateResType": "",
     "relateResId": null,
     "tsSongCount": 0,
     "algType": "",
     "playlistType": "PGC",
     "uiPlaylistType": "PGC",
     "originalCoverId": 0,
     "backgroundImageId": 0,
     "backgroundImageUrl": null,
     "topTrackIds": null,
     "promptedMgcInfo": null,
     "title": "KPOP红心宝藏",
     "subTitle": "高收藏率KPop仙曲推荐",
     "backgroundText": "KPOP红心宝藏",
     "mix": false,
     "shareCount": 10,
     "coverImgId_str": "109951172322266593",
     "alg": "op_rcmd",
     "commentCount": 11
 },
 },
 */

struct Playlist: Decodable, Identifiable {
    let id: Int
    let name: String
    let coverImgId: Int
    let coverImgUrl: String
    let coverText: [String]?
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
