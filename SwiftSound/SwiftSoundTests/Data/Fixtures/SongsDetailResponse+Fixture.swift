//
//  SongsDetailResponse+Fixture.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/24.
//

import Foundation
@testable import SwiftSound

extension SongsDetailResponse {
    static func rawData() throws -> Data {
        try JSONFixture.data(named: "SongsDetailResponse.json")
    }
}
