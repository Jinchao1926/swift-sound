//
//  PlaylistDetailResponse+Fixture.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation

@testable import SwiftSound

extension PlaylistDetailResponse {
    static func rawData() throws -> Data {
        try JSONFixture.data(named: "PlaylistDetailResponse.json")
    }
}
