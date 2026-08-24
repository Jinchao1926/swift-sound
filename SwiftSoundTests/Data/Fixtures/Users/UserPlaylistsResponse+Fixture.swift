//
//  UserPlaylistsResponse+Fixture.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/8/24.
//

import Foundation
@testable import SwiftSound

extension UserPlaylistsResponse {
    static func rawData() throws -> Data {
        try JSONFixture.data(named: "Users/UserPlaylistsResponse.json")
    }
}
