//
//  SongPlaybackURL.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/26.
//

import Foundation

/**
 {
     "id": 64517,
     "url": "http://m801.music.126.net/20260626121746/b58c4cc88162859f2dee0ae930c64cf2/jdymusic/obj/wo3DlMOGwrbDjj7DisKw/28481994573/bd2f/4df1/0462/7cf73c521468ef604786e3806cf1bb95.mp3?vuutv=Q0tECsaZWfXoTEBC9h+GP7AfaIXKgFl1JyUDwqSkqQxVDzVqSVIbKWQ8xyd9+umZJhKGI3DkBUkFv9lHqT5iXShD4kRhrD6FjzVVWO9bIDE=",
     "br": 128000,
     "size": 4784840,
     "md5": "7cf73c521468ef604786e3806cf1bb95",
     "code": 200,
     "expi": 1200,
     "type": "mp3",
     "gain": -5.2158,
     "peak": 1,
     "closedGain": -6,
     "closedPeak": 1,
     "fee": 8,
     "uf": null,
     "payed": 0,
     "flag": 458756,
     "canExtend": false,
     "freeTrialInfo": null,
     "level": "standard",
     "encodeType": "mp3",
     "channelLayout": null,
     "freeTrialPrivilege": {
         "resConsumable": false,
         "userConsumable": false,
         "listenType": null,
         "cannotListenReason": null,
         "playReason": null,
         "freeLimitTagType": null
     },
     "freeTimeTrialPrivilege": {
         "resConsumable": false,
         "userConsumable": false,
         "type": 0,
         "remainTime": 0
     },
     "urlSource": 0,
     "rightSource": 0,
     "podcastCtrp": null,
     "effectTypes": null,
     "time": 298973,
     "message": null,
     "levelConfuse": null,
     "musicId": "8169486478",
     "accompany": null,
     "sr": 44100,
     "auEff": null,
     "immerseType": null,
     "beatType": 0
 }
 */
enum SongPlaybackQuality: String, CaseIterable, Codable {
    /// 标准
    case standard
    /// 较高
    case higher
    /// 极高
    case exhigh
    /// 无损
    case lossless
    /// Hi-Res
    case hires
    /// 高清环绕声
    case jyeffect
    /// 沉浸环绕声
    case sky
    /// 超清母带
    case jymaster
}

struct SongPlaybackURL: nonisolated Decodable {
    let id: Int
    let url: String
    let type: String?  // eg: mp3
    let level: SongPlaybackQuality?
    // 时长，毫秒
    let time: Int
    let size: Int
}
