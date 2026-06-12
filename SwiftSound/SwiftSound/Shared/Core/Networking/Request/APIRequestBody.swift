//
//  APIRequestBody.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Foundation

/// Encoded request payload plus its content type.
struct APIRequestBody {
    let contentType: String?
    let data: Data

    static func json<Value: Encodable>(
        _ value: Value,
        encoder: JSONEncoder = .swiftSoundDefault
    ) throws -> APIRequestBody {
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
