//
//  TopPlaylistsResponse+Fixture.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation
@testable import SwiftSound

extension TopPlaylistsResponse {
    static func rawData() throws -> Data {
        try JSONFixture.data(named: "Playlists/TopPlaylistsResponse.json")
    }
}
