//
//  NewSong.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation

/**
 {
     "id": 3382908505,
     "type": 4,
     "name": "玻璃",
     "copywriter": null,
     "picUrl": "http://p1.music.126.net/MSKoQP60up7v3y1P1d3JIQ==/109951173234747322.jpg",
     "canDislike": false,
     "trackNumberUpdateTime": null,
     "song": {
         "name": "玻璃",
         "id": 3382908505,
         "position": 0,
         "alias": [],
         "status": 0,
         "fee": 8,
         "copyrightId": 7002,
         "disc": "01",
         "no": 1,
         "artists": [
             {
                 "name": "Gareth.T",
                 "id": 32944030,
                 "picId": 0,
                 "img1v1Id": 0,
                 "briefDesc": "",
                 "picUrl": "",
                 "img1v1Url": "http://p3.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg",
                 "albumSize": 0,
                 "alias": [],
                 "trans": "",
                 "musicSize": 0,
                 "topicPerson": 0
             }
         ],
         "album": {
             "name": "玻璃",
             "id": 376798712,
             "type": "Single",
             "size": 1,
             "picId": 109951173234747330,
             "blurPicUrl": "http://p3.music.126.net/MSKoQP60up7v3y1P1d3JIQ==/109951173234747322.jpg",
             "companyId": 0,
             "pic": 109951173234747330,
             "picUrl": "http://p4.music.126.net/MSKoQP60up7v3y1P1d3JIQ==/109951173234747322.jpg",
             "publishTime": 1779206400000,
             "description": "",
             "tags": "",
             "company": "华纳音乐",
             "briefDesc": "",
             "artist": {
                 "name": "",
                 "id": 0,
                 "picId": 0,
                 "img1v1Id": 0,
                 "briefDesc": "",
                 "picUrl": "",
                 "img1v1Url": "http://p3.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg",
                 "albumSize": 0,
                 "alias": [],
                 "trans": "",
                 "musicSize": 0,
                 "topicPerson": 0
             },
             "songs": [],
             "alias": [],
             "status": 1,
             "copyrightId": 7002,
             "commentThreadId": "R_AL_3_376798712",
             "artists": [
                 {
                     "name": "Gareth.T",
                     "id": 32944030,
                     "picId": 0,
                     "img1v1Id": 0,
                     "briefDesc": "",
                     "picUrl": "",
                     "img1v1Url": "http://p4.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg",
                     "albumSize": 0,
                     "alias": [],
                     "trans": "",
                     "musicSize": 0,
                     "topicPerson": 0
                 }
             ],
             "subType": "录音室版",
             "transName": null,
             "onSale": false,
             "mark": 0,
             "gapless": 0,
             "picId_str": "109951173234747322"
         },
         "starred": false,
         "popularity": 100,
         "score": 100,
         "starredNum": 0,
         "duration": 185040,
         "playedNum": 0,
         "dayPlays": 0,
         "hearTime": 0,
         "ringtone": "",
         "crbt": null,
         "audition": null,
         "copyFrom": "",
         "commentThreadId": "R_SO_4_3382908505",
         "rtUrl": null,
         "ftype": 0,
         "rtUrls": [],
         "copyright": 1,
         "transName": null,
         "sign": null,
         "mark": 0,
         "originCoverType": 1,
         "originSongSimpleData": null,
         "single": 0,
         "noCopyrightRcmd": null,
         "mvid": 34759031,
         "rtype": 0,
         "rurl": null,
         "mp3Url": null,
         "publishTime": 1779206400000,
         "privilege": { ... }
         }
     },
     "alg": "server_doudi"
 },
 */

struct NewSong: Decodable, Identifiable {
    let id: Int
    let type: Int
    let name: String
    let picUrl: String
    let song: Song
}

extension NewSong {
    var artistName: String? { song.artistName }

    var hasMV: Bool { song.hasMV }
}
