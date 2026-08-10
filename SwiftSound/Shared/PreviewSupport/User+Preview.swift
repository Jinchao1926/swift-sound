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
    static let preview = User(
        userId: 97137413,
        nickname: "薛之谦",
        avatarUrl: "http://p2.music.126.net/PLrMsE0bTG2p1lL6QfKC9g==/109951172414278510.jpg",
        avatarDetail: Identity(
            identityLevel: 1,
            identityIconUrl: "https://p5.music.126.net/obj/wo3DlcOGw6DClTvDisK1/4788940880/1a1f/68f5/b59a/b444b81b88567108ba88194fa29144f5.png"
        )
    )
}
// swiftlint:enable line_length
#endif
