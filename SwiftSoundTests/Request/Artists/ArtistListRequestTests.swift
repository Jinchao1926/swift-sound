//
//  ArtistListRequestTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/7/22.
//

import Testing
import Foundation
@testable import SwiftSound

struct ArtistListRequestTests {

    @Test func decodesArtistListResponseFixture() throws {
        let data = try ArtistListResponse.rawData()
        let response = try JSONDecoder.swiftSoundDefault.decode(ArtistListResponse.self, from: data)
        let artist = try #require(response.artists.last)

        #expect(response.code == 200)
        #expect(response.artists.count == 3)

        #expect(artist.id == 2116)
        #expect(artist.name == "陈奕迅")
        #expect(artist.albumSize == 133)
        #expect(artist.musicSize == 1856)
        #expect(artist.img1v1Url != nil)
        #expect(artist.picUrl != nil)
    }
}
