//
//  PlaylistDetailRequestTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation
import Testing
@testable import SwiftSound

struct PlaylistDetailRequestTests {

    @Test func decodesPlaylistDetailFixture() throws {
        let data = try PlaylistDetailResponse.rawData()
        let response = try JSONDecoder.swiftSoundDefault.decode(PlaylistDetailResponse.self, from: data)
        let playlist = response.playlist
        let track = try #require(playlist.tracks?.first)

        #expect(response.code == 200)
        #expect(playlist.id == 8163014104)
        #expect(playlist.name == "欧美流行新歌 | Olivia Rodrigo,霉霉,A妹引领本周欧美新歌")
        #expect(playlist.trackCount == 202)
        #expect(playlist.playCount == 15015965)
        #expect(playlist.creator.userId == 9195422918)
        #expect(playlist.creator.nickname == "云音乐欧美星球")
        #expect(playlist.subscribers.count == 8)

        #expect(track.id == 3392742809)
        #expect(track.name == "stupid song")
        #expect(track.duration == 209680)
        #expect(track.artists.first?.id == 12132544)
        #expect(track.artists.first?.name == "Olivia Rodrigo")
        #expect(track.album.name == "you seem pretty sad for a girl so in love")
        #expect(track.aliases.isEmpty)
        #expect(track.mvId == 34765683)
        #expect(track.fee == .limitedFree)
    }
}
