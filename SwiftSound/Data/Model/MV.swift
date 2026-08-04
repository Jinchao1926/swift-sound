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
