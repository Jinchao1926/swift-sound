//
//  SwiftSoundTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/11.
//

import Testing
import Foundation
@testable import SwiftSound

struct TopPlaylistsRequestTests {

    @Test func decodesTopPlaylistFixture() throws {
        let data = try TopPlaylistsResponse.rawData()
        let response = try JSONDecoder.swiftSoundDefault.decode(TopPlaylistsResponse.self, from: data)
        let playlist = try #require(response.playlists.first)

        #expect(response.code == 200)
        #expect(response.total == 1292)
        #expect(response.more)
        #expect(response.cat == "官方")
        #expect(response.playlists.count == 10)

        #expect(playlist.id == 8_159_674_692)
        #expect(playlist.name == "全球流行趋势 | 黄丽玲,Olivia Rodrigo,米津玄师和更多好歌")
        #expect(playlist.coverImgId == 109_951_173_388_746_180)
        #expect(playlist.trackCount == 60)
        #expect(playlist.tracks == nil)
        #expect(playlist.playCount == 6_679_959)
        #expect(playlist.shareCount == 138)
        #expect(playlist.commentCount == 33)
        #expect(playlist.subscribedCount == 10_479)
        #expect(playlist.creator.userId == 1_463_586_082)
        #expect(playlist.creator.nickname == "云音乐官方歌单")
        #expect(playlist.creator.avatarDetail?.identityLevel == 1)
        #expect(playlist.subscribers.count == 1)
        #expect(playlist.subscribers.first?.nickname == "小仙丹吖")
    }
}
