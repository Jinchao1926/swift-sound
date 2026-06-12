//
//  APIEnums.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Foundation

enum APIHTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: LocalizedError {
    case invalidURL(String)
    case invalidResponse
    case requestFailed(statusCode: Int?, message: String?, underlying: Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let path):
            "Invalid API URL: \(path)"
        case .invalidResponse:
            "The server returned an invalid response."
        case .requestFailed(let statusCode, let message, _):
            if let statusCode, let message {
                "Request failed with status \(statusCode): \(message)"
            } else if let statusCode {
                "Request failed with status \(statusCode)."
            } else {
                "Request failed."
            }
        }
    }
}
