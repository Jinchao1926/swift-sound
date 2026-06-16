//
//  APICachePolicy.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Foundation

/// Controls decoded response caching for an APIRequest.
///
/// This cache sits above Alamofire and stores typed response objects, not raw
/// HTTP responses. Use `.none` for user-specific or frequently changing data.
nonisolated enum APICachePolicy {
    case none
    case memory(ttl: TimeInterval)

    var isEnabled: Bool {
        switch self {
        case .none:
            false
        default:
            true
        }
    }

    var ttl: TimeInterval? {
        switch self {
        case .none:
            nil
        case .memory(let ttl):
            ttl
        }
    }
}
