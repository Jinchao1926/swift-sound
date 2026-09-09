//
//  Playlist+Preview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import Foundation

#if DEBUG
// swiftlint:disable line_length
extension Playlist {
    static let preview = Playlist(
        id: 19723756,
        name: "飙升榜",
        coverImgId: 109951170048506930,
        coverImgUrl: "https://p1.music.126.net/rIi7Qzy2i2Y_1QD7cd0MYA==/109951170048506929.jpg",
        coverText: nil,
        createTime: 1404115136883,
        creator: User.official,
        description: "云音乐中每天热度上升最快的100首单曲，每日更新。",
        tags: [],
        updateFrequency: nil,
        updateTime: 1786520598969,
        trackUpdateTime: 1786520599073,
        trackNumberUpdateTime: 1786520598860,
        tracks: nil,
        trackCount: 100,
        playCount: 6484366336,
        shareCount: 17118,
        commentCount: 227610,
        subscribedCount: 4207142,
        subscribers: [User.preview]
    )

    static let featuredPreview = Playlist(
        id: 3001035934,
        name: "国风新潮大赏 | 歌声岂合世间闻",
        coverImgId: 109951168239184660,
        coverImgUrl: "http://p1.music.126.net/6lhQ6jqPaBfsRdOJEgeiYw==/109951168239184663.jpg",
        coverText: nil,
        createTime: 1569494978983,
        creator: User.official,
        description: "随着继承并弘扬传统文化的呼声日益高涨，诸多制作精良的古装影视作品问世，广受都市人们的喜爱。同时，结合中国元素的流行歌曲，也备受瞩目。\n\n本歌单收录了含人声的国风摇滚、说唱、电子、戏腔、民谣。当然还有国风爵士等类型少量收录，有机会会继续收录哒！\n\n此刻，就让我们沉溺在不一样的国风浪潮中，感受华夏大地的悠扬古韵吧！\n\n（封面来源网络，侵删致歉。）",
        tags: [],
        updateFrequency: nil,
        updateTime: 1724396094000,
        trackUpdateTime: 1785149100260,
        trackNumberUpdateTime: 1724205059438,
        tracks: nil,
        trackCount: 137,
        playCount: 13605744,
        shareCount: 1545,
        commentCount: 341,
        subscribedCount: 79161,
        subscribers: [User.preview]
    )
}

extension Toplist {
    static let defaultPreview = Toplist(
        id: 5_059_661_515,
        name: "网易云民谣榜",
        coverImgId: 109_951_170_048_510_930,
        coverImgUrl: "https://p2.music.126.net/Xe9qLTAqtBAWX_hPgFHMyw==/109951170048510929.jpg",
        createTime: 1_591_863_052_757,
        description: "网易云用户一周内收听所有民谣歌曲官方TOP排行榜，每周五更新。",
        tags: [],
        updateFrequency: "每周五更新",
        tracks: nil
    )

    static let titlePreview = Toplist(
        id: 180_106,
        name: "UK排行榜周榜",
        coverImgId: 109_951_165_613_082_770,
        coverImgUrl: "https://p2.music.126.net/fhAqiflLy3eU-ldmBQByrg==/109951165613082765.jpg",
        createTime: 1_361_239_766_844,
        description: "UK排行榜",
        tags: ["榜单", "欧美"],
        updateFrequency: "刚刚更新",
        tracks: nil
    )

    static let flagPreview = Toplist(
        id: 2_809_513_713,
        name: "网易云欧美热歌榜",
        coverImgId: 109_951_167_430_862_160,
        coverImgUrl: "https://p2.music.126.net/70_EO_Dc7NT_hhfvsapzcQ==/109951167430862162.jpg",
        createTime: 1_558_493_373_769,
        description: "网易云用户一周内收听所有欧美歌曲官方TOP排行榜，每周四更新。\nWestern Hit Chart (updated every Thursday)",
        tags: ["榜单", "欧美"],
        updateFrequency: "每周四更新",
        tracks: nil
    )

    static let officialRankingPreview = Toplist(
        id: 19_723_756,
        name: "飙升榜",
        coverImgId: 109_951_170_048_506_930,
        coverImgUrl: "https://p2.music.126.net/rIi7Qzy2i2Y_1QD7cd0MYA==/109951170048506929.jpg",
        createTime: 1_404_115_136_883,
        description: "云音乐中每天热度上升最快的100首单曲，每日更新。",
        tags: [],
        updateFrequency: "刚刚更新",
        tracks: [
            .init(first: "交个朋友 (Live)", second: "弹壳Danko"),
            .init(first: "Sunquan March（孙权进行曲）", second: "XiRXG"),
            .init(first: "小rapper", second: "Rapeter")
        ]
    )
}
// swiftlint:enable line_length
#endif
