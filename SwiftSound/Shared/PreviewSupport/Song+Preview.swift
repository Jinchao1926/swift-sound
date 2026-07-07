//
//  Song+Preview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/24.
//

import Foundation

#if DEBUG
extension SongPrivilege {
    static let preview = SongPrivilege(
        chargeInfoList: [
            .init(rate: 128000, chargeType: 0),
            .init(rate: 192000, chargeType: 0),
            .init(rate: 320000, chargeType: 0),
            .init(rate: 999000, chargeType: 1)
        ]
    )
}

extension Song {
    static let preview = Song(
        id: 64517,
        name: "富士山下(Live)",
        duration: 298973,
        artists: [.preview],
        album: .preview,
        tns: nil,
        aliases: [],
        mvId: 5570930,
        fee: .limitedFree,
        mark: 17179877376,
        originCoverType: .originalTrack,
        privilege: .preview
    )
}
#endif
