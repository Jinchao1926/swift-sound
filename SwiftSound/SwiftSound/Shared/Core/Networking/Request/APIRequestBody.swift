//
//  APIRequestBody.swift
//  SwiftSound
//
//  Created by Codex on 2026/6/12.
//

import Foundation

struct APIRequestBody: Sendable {
    let contentType: String?
    let data: Data

    static func json<Value: Encodable>(
        _ value: Value,
        encoder: JSONEncoder = .swiftSoundDefault
    ) throws -> APIRequestBody where Value: Sendable {
        APIRequestBody(
            contentType: "application/json",
            data: try encoder.encode(value)
        )
    }

    static func data(
        _ data: Data,
        contentType: String? = nil
    ) -> APIRequestBody {
        APIRequestBody(contentType: contentType, data: data)
    }
}
