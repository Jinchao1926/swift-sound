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

        #expect(response.code == 200)
        #expect(playlist.id == 8163014104)
    }
}
