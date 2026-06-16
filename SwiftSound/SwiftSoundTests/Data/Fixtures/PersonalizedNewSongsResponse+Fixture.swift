//
//  PersonalizedNewSongsResponse+Fixture.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation
@testable import SwiftSound

extension PersonalizedNewSongsResponse {
    static func rawData() throws -> Data {
        try JSONFixture.data(named: "PersonalizedNewSongsResponse.json")
    }
}
