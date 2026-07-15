//
//  SongPlaybackURLResponseTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/11.
//

import Testing
import Foundation
@testable import SwiftSound

struct SongPlaybackURLResponseTests {

    @Test func decodesSongPlaybackURLResponseFixture() throws {
        let data = try SongPlaybackURLResponse.rawData()
        let response = try JSONDecoder.swiftSoundDefault.decode(SongPlaybackURLResponse.self, from: data)
        let playback = try #require(response.data.first)

        #expect(response.code == 200)
        #expect(response.data.count == 1)

        #expect(playback.id == 64517)
        #expect(playback.url != nil)
        #expect(playback.type == "mp3")
        #expect(playback.level == .standard)
        #expect(playback.time == 298973)
        #expect(playback.size == 4784840)
    }
}
