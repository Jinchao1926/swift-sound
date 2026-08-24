//
//  UserPlaylistsRequestTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/8/24.
//

import Testing
import Foundation
@testable import SwiftSound

struct UserPlaylistsRequestTests {

    @Test func decodesUserPlaylistsResponseFixture() throws {
        let data = try UserPlaylistsResponse.rawData()
        let response = try JSONDecoder.swiftSoundDefault.decode(UserPlaylistsResponse.self, from: data)
        let playlist = try #require(response.playlist.first)

        #expect(response.code == 200)

        #expect(playlist.id == 397608592)
        #expect(playlist.name == "Mandyisagirl喜欢的音乐")
    }
}
