//
//  SongPlaybackURLResponse+Fixture.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/26.
//

import Foundation
@testable import SwiftSound

extension SongPlaybackURLResponse {
    static func rawData() throws -> Data {
        try JSONFixture.data(named: "SongPlaybackURLResponse.json")
    }
}
