//
//  User+Preview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import Foundation

#if DEBUG
// swiftlint:disable line_length
extension User {
    static let official = User(
        userId: 1,
        nickname: "网易云音乐",
        gender: .male,
        avatarUrl: "http://p1.music.126.net/kMuXXbwHbduHpLYDmHXrlA==/109951168152833223.jpg",
        avatarDetail: AvatarDetail(
            identityLevel: 1,
            identityIconUrl: "https://p5.music.126.net/obj/wo3DlcOGw6DClTvDisK1/4788940880/1a1f/68f5/b59a/b444b81b88567108ba88194fa29144f5.png"
        ),
        description: "网易云音乐官方账号",
        signature: "网易云音乐是8亿人都在使用的音乐平台，致力于帮助音乐爱好者发现音乐惊喜，帮助音乐人实现梦想。 \n2019年8月31日起，将不再提供实时在线人工服务。您可以优先通过自助方式解决问题，如仍需求助，可在相关页面留下您的问题，后续会有人工为您解答，辛苦您耐心等待，给您带来的不便敬请谅解。 如果仍然不能解决您的问题，可以邮件我们： 用户：ncm5990@163.com 音乐人：yyr599@163.com",
        vipType: 11,
        province: 110000,
        city: 110101,
        followeds: 99999,
        follows: 576,
        playlistCount: 797,
        eventCount: nil,
        artistId: nil
    )

    static let preview = User(
        userId: 97137413,
        nickname: "薛之谦",
        gender: .male,
        avatarUrl: "http://p2.music.126.net/PLrMsE0bTG2p1lL6QfKC9g==/109951172414278510.jpg",
        avatarDetail: AvatarDetail(
            identityLevel: 1,
            identityIconUrl: "https://p5.music.126.net/obj/wo3DlcOGw6DClTvDisK1/4788940880/1a1f/68f5/b59a/b444b81b88567108ba88194fa29144f5.png"
        ),
        description: "原创歌手薛之谦",
        signature: nil,
        vipType: 0,
        province: 110000,
        city: 110101,
        followeds: 21147216,
        follows: 0,
        playlistCount: 0,
        eventCount: nil,
        artistId: 5781
    )
}

extension UserDetail {
    static let preview = UserDetail(
        identify: .preview,
        profile: .preview,
        level: 1,
        listenSongs: 24,
        createTime: 1450170569106,
        createDays: 3904,
        code: 200
    )
}

extension Identify {
    static let preview = Identify(
        imageUrl: "https://p5.music.126.net/obj/wo3DlcOGw6DClTvDisK1/4788940880/1a1f/68f5/b59a/b444b81b88567108ba88194fa29144f5.png",
        imageDesc: "原创歌手薛之谦"
    )
}
// swiftlint:enable line_length
#endif
