//
//  ArtistListResponse+Fixture.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/7/22.
//

import Foundation
@testable import SwiftSound

extension ArtistListResponse {
    static func rawData() throws -> Data {
        try JSONFixture.data(named: "Artists/ArtistListResponse.json")
    }
}
