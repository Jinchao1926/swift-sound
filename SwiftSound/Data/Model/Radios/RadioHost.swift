//
//  RadioHost.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Foundation

/**
 {
     "id": 45218094,
     "rank": 1,
     "lastRank": -1,
     "score": 2278448,
     "nickName": "云音乐播客",
     "avatarUrl": "https://p2.music.126.net/IxEnoxhgIqMOFNzWo_3wrA==/109951170310313168.jpg",
     "userType": 10,
     "userFollowedCount": 191641,
     "mainAuthDesc": "",
     "liveStatus": -1,
     "liveType": 0,
     "liveId": 0,
     "avatarDetail": {
         "userType": 10,
         "identityLevel": 1,
         "identityIconUrl": "https://p5.music.126.net/obj/wo3DlcOGw6DClTvDisK1/4788940880/1a1f/68f5/b59a/b444b81b88567108ba88194fa29144f5.png"
     },
     "roomNo": 0
 },
 */
struct RadioHost: Decodable, Identifiable {
    let id: Int
    let rank: Int
    let lastRank: Int
    let score: Int
    let nickName: String
    let avatarUrl: String
    let avatarDetail: AvatarDetail?
}
