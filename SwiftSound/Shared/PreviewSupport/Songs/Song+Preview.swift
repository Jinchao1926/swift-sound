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

extension SongAudioFile {
    static let preview = SongAudioFile(
        bitrate: 865813, fileId: 0, size: 32356901, volumeDelta: -16396, sampleRate: 44100
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
        hiResAudio: .preview,
        originCoverType: .originalTrack,
        privilege: .preview
    )

    static let preview1 = Song(
        id: 64556,
        name: "一丝不挂(Live)",
        duration: 284693,
        artists: [.preview],
        album: .preview,
        tns: nil,
        aliases: [],
        mvId: 5570936,
        fee: .limitedFree,
        mark: 17179877376,
        hiResAudio: .preview,
        originCoverType: .originalTrack,
        privilege: .preview
    )

    static let preview2 = Song(
        id: 64443,
        name: "约定(Live)",
        duration: 336254,
        artists: [.preview],
        album: .preview,
        tns: nil,
        aliases: [],
        mvId: 5570935,
        fee: .vip,
        mark: 17179877376,
        hiResAudio: .preview,
        originCoverType: .originalTrack,
        privilege: .preview
    )
}

extension Array where Element == Song {
    static let songsPreview = [Song.preview, Song.preview1, Song.preview2]
}
#endif
