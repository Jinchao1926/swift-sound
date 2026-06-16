//
//  NewSongRequestTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/11.
//

import Testing
import Foundation
@testable import SwiftSound

struct NewSongRequestTests {

    @Test func decodesNewSongResponseFixture() throws {
        let data = try NewSongResponse.rawData()
        let response = try JSONDecoder.swiftSoundDefault.decode(NewSongResponse.self, from: data)
        let newSong = try #require(response.result.first)

        #expect(response.code == 200)
        #expect(response.result.count == 1)

        #expect(newSong.id == 3382908505)
        #expect(newSong.type == 4)
        #expect(newSong.name == "玻璃")
        #expect(!newSong.picUrl.isEmpty)

        #expect(newSong.song.id == 3382908505)
        #expect(newSong.song.name == "玻璃")
        #expect(newSong.song.duration == 185040)
        #expect(newSong.song.artists.first?.id == 32944030)
        #expect(newSong.song.artists.first?.name == "Gareth.T")
        #expect(newSong.song.album.id == 376798712)
        #expect(newSong.song.album.name == "玻璃")
        #expect(newSong.song.aliases.isEmpty)
        #expect(newSong.song.mvId == 34759031)
        #expect(newSong.song.fee == .limitedFree)
        #expect(newSong.song.mark == 0)
    }
}
