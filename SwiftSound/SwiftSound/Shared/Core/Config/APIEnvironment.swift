//
//  APIEnvironment.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Foundation

nonisolated enum APIEnvironment: String, CaseIterable, Identifiable {
    case development
    case staging
    case production

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .development:
            "Development"
        case .staging:
            "Staging"
        case .production:
            "Production"
        }
    }

    // swiftlint:disable force_unwrapping
    var defaultBaseURL: URL {
        switch self {
        case .development:
            URL(string: "http://localhost:5001")!
        case .staging:
            URL(string: "https://staging-api.swiftsound.app")!
        case .production:
            URL(string: "https://api.swiftsound.app")!
        }
    }
    // swiftlint:enable force_unwrapping
}
