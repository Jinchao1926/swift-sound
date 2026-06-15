//
//  JSONFixture.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation
@testable import SwiftSound

enum JSONFixture {
    static func data(named fileName: String) throws -> Data {
        let fixturesURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
        let jsonsURL = fixturesURL
            .deletingLastPathComponent()
            .appendingPathComponent("JSONS")

        return try Data(contentsOf: jsonsURL.appendingPathComponent(fileName))
    }

    static func decode<T: Decodable>(
        _ type: T.Type,
        from fileName: String,
        decoder: JSONDecoder = .swiftSoundDefault
    ) throws -> T {
        let data = try data(named: fileName)
        return try decoder.decode(type, from: data)
    }
}
