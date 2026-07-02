//
//  LyricRequestTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/11.
//

import Testing
import Foundation
@testable import SwiftSound

struct LyricRequestTests {

    @Test func decodesLyricResponseFixture() throws {
        let data = try LyricResponse.rawData()
        let response = try JSONDecoder.swiftSoundDefault.decode(LyricResponse.self, from: data)

        #expect(response.code == 200)

        #expect(response.lrc.version != 0)
        #expect(!response.lrc.lyric.isEmpty)

        #expect(response.romalrc.version != 0)
        #expect(!response.romalrc.lyric.isEmpty)
    }
}
