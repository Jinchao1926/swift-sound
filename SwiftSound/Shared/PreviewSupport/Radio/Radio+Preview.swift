//
//  Radio+Preview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/3.
//

import Foundation

#if DEBUG
// swiftlint:disable line_length
extension Radio {
    static let preview = Radio(
        id: 1214365542,
        name: "弦外之音·R&B",
        rcmdtext: nil,
        picUrl: "https://p2.music.126.net/VZxqS0_cf0kySQKoDqjoIA==/109951170029030546.jpg",
        desc: "「弦外之音」是一档由网易云音乐官方全力打造的音乐播客系列。我们将聚焦在说唱、R&B、电音、摇滚、二次元以及流行等各个曲风系列，为大家提供最深度的音乐行业分析、最详实的曲风编年史、最温暖的音乐人物故事以及最有趣的文化漫谈，这是“音乐+商业”的结合体。说唱系列请关注「弦外之音·说唱」，后续将上线「弦外之音·电音」、「弦外之音·摇滚」、「弦外之音·二次元」等。",
        createTime: 1728441179473,
        categoryId: 2,
        category: "音乐播客",
        secondCategory: "音乐故事",
        lastProgramId: 3065451834,
        lastProgramName: "【R&B岁月鸟瞰】全局视角聊聊华语R&B发展历程",
        lastProgramCreateTime: 1730952254323,
        programCount: 2,
        subCount: 92,
        playCount: 0,
        shareCount: nil,
        likedCount: nil,
        commentCount: nil,
        dj: .official
    )

    static let preview1 = Radio(
        id: 793386477,
        name: "我想治愈你｜温柔晚安电台",
        rcmdtext: "用最温柔的声音为你讲睡前情话",
        picUrl: "https://p2.music.126.net/w_iwuVQOQBxwltgxrp4Vlg==/109951173191013974.jpg",
        desc: "百万人喜欢听的温柔御姐音~ 每晚伴你入眠~（喜欢记得:收藏 评论 转发和留言噢~~~）",
        createTime: 1561393821511,
        categoryId: 3,
        category: "情感",
        secondCategory: "情感故事",
        lastProgramId: 3718933070,
        lastProgramName: "【R&B岁月鸟瞰】全局视角聊聊华语R&B发展历程",
        lastProgramCreateTime: 1786971600000,
        programCount: 2,
        subCount: 8241,
        playCount: 0,
        shareCount: 30,
        likedCount: 0,
        commentCount: 301,
        dj: .init(
            userId: 330227947,
            nickname: "夏治愈428",
            gender: .female,
            avatarUrl: "http://p1.music.126.net/bQqTofOZzTW500C69oIzvA==/109951172522315457.jpg",
            avatarDetail: .init(
                identityLevel: 3,
                identityIconUrl: "https://p5.music.126.net/obj/wo3DlcOGw6DClTvDisK1/4761340168/ccce/35dd/ab2d/1a7c8ee0f6bb1fc2760cbb570dfee34f.png"
            ),
            description: "",
            signature: "温柔治愈女声  资深电台主播  商业🌍：xwt3156628248",
            vipType: 11,
            province: 440000,
            city: 440300,
            followeds: nil,
            follows: nil,
            playlistCount: nil,
            eventCount: nil,
            artistId: nil
        )
    )
}
// swiftlint:enable line_length

struct RankingPreview: RankingInfoProviding {
    var id: Int
    var lastRank: Int
    var rank: Int
    var score: Int
}

extension RankingPreview {
    static let new = RankingPreview(id: 1, lastRank: -1, rank: 1, score: 0)
    static let down = RankingPreview(id: 2, lastRank: 1, rank: 2, score: 0)
    static let up = RankingPreview(id: 3, lastRank: 4, rank: 2, score: 0)
    static let unchange = RankingPreview(id: 4, lastRank: 3, rank: 3, score: 0)
}
#endif
