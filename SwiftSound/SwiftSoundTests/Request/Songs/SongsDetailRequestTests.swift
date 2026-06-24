//
//  SongsDetailRequestTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/11.
//

import Testing
import Foundation
@testable import SwiftSound

struct SongsDetailRequestTests {

    @Test func decodesSongsDetailResponseFixture() throws {
        let data = try SongsDetailResponse.rawData()
        let response = try JSONDecoder.swiftSoundDefault.decode(SongsDetailResponse.self, from: data)
        let song = try #require(response.songs.first)

        #expect(response.code == 200)
        #expect(response.songs.count == 1)

        #expect(song.id == 64517)
        #expect(song.name == "富士山下(Live)")
        #expect(song.duration == 298973)
        #expect(song.artists.first?.id == 2116)
        #expect(song.artists.first?.name == "陈奕迅")
        #expect(song.album.id == 6365)
        #expect(song.album.name == "DUO 陈奕迅2010演唱会")
        #expect(song.aliases.isEmpty)
        #expect(song.mvId == 5570930)
        #expect(song.fee == .limitedFree)
        #expect(song.mark == 17179877376)
    }
}
