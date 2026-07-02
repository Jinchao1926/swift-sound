//
//  LyricResponse+Fixture.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/7/2.
//

import Foundation
@testable import SwiftSound

extension LyricResponse {
    static func rawData() throws -> Data {
        try JSONFixture.data(named: "LyricResponse.json")
    }
}
