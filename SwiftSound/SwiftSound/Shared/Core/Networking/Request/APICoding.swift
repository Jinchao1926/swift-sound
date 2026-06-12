//
//  APICoding.swift
//  SwiftSound
//
//  Created by Codex on 2026/6/12.
//

import Foundation

extension JSONDecoder {
    static var swiftSoundDefault: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

extension JSONEncoder {
    static var swiftSoundDefault: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}
