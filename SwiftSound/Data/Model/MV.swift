//
//  MV.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/3.
//

import Foundation

/**
 {
     "id": 14236176,
     "name": "夕阳无限好",
     "status": 0,
     "artist": {
         "img1v1Id": 18686200114669624,
         "topicPerson": 0,
         "musicSize": 0,
         "albumSize": 0,
         "alias": [],
         "picId": 0,
         "briefDesc": "",
         "picUrl": "",
         "img1v1Url": "http://p1.music.126.net/VnZiScyynLG7atLIZ2YPkw==/18686200114669622.jpg",
         "trans": "",
         "name": "陈奕迅",
         "id": 2116,
         "img1v1Id_str": "18686200114669622"
     },
     "imgurl": "http://p1.music.126.net/R9MbEWZ9IBRrrfauJbY8nw==/109951173573691735.jpg",
     "artistName": "陈奕迅",
     "imgurl16v9": "http://p1.music.126.net/R9MbEWZ9IBRrrfauJbY8nw==/109951173573691735.jpg",
     "duration": 246000,
     "playCount": 1038,
     "publishTime": "2026-07-17",
     "subed": false
 }
 */
struct MV: Decodable, Identifiable {
    let id: Int
    let name: String
    let artist: Artist
    let artistName: String
    let imgurl: String
    let imgurl16v9: String
    let duration: Int
    let playCount: Int
    let publishTime: String
    let subed: Bool
}

extension MV {
    var imageURL: URL? { URL(string: imgurl) }
}

/**
 {
     "id": 14236176,
     "name": "夕阳无限好",
     "artistId": 2116,
     "artistName": "陈奕迅",
     "briefDesc": "",
     "desc": "",
     "cover": "http://p1.music.126.net/R9MbEWZ9IBRrrfauJbY8nw==/109951173573691735.jpg",
     "coverId_str": "109951173573691735",
     "coverId": 109951173573691730,
     "playCount": 1079,
     "subCount": 0,
     "shareCount": 0,
     "commentCount": 4,
     "duration": 246000,
     "nType": 0,
     "publishTime": "2026-07-17",
     "price": null,
     "brs": [
         {
             "size": 16388132,
             "br": 240,
             "point": 0
         },
         {
             "size": 26110834,
             "br": 480,
             "point": 0
         }
     ],
     "artists": [
         {
             "id": 2116,
             "name": "陈奕迅",
             "img1v1Url": null,
             "followed": false
         }
     ],
     "commentThreadId": "R_MV_5_14236176",
     "videoGroup": []
 */
struct MVDetail: Decodable, Identifiable {
    let id: Int
    let name: String
    let artistId: Int
    let artistName: String
    let artists: [Artist]
    let cover: String
    let duration: Int
    let playCount: Int
    let subCount: Int
    let shareCount: Int
    let commentCount: Int
    let publishTime: String
}

/*
{
    "id": 349989,
    "url": "http://vodkgeyttp8.vod.126.net/cloudmusic/IyQhMSAyIDBgMDUmISFiIQ==/mv/349989/30cdeb0e52a60a45298e8eef1757a53a.mp4?wsSecret=e00da529da2efd0a406fb0f93249f2c2&wsTime=1764729475",
    "r": 1080,
    "size": 120615536,
    "md5": "",
    "code": 200,
    "expi": 3600,
    "fee": 0,
    "mvFee": 0,
    "st": 0,
    "promotionVo": null,
    "msg": ""
}
*/
struct MVURL: Decodable, Identifiable {
    let id: Int
    let url: String
    let r: Int
    let size: Int
}
