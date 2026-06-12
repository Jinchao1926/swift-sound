//
//  APIRequest.swift
//  SwiftSound
//
//  Created by Codex on 2026/6/12.
//

import Foundation

protocol APIRequest: Sendable {
    associatedtype Response: Decodable & Sendable

    var path: String { get }
    var method: APIHTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var body: APIRequestBody? { get }
    var decoder: @Sendable () -> JSONDecoder { get }
}

extension APIRequest {
    var method: APIHTTPMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    var body: APIRequestBody? { nil }
    var decoder: @Sendable () -> JSONDecoder { { .swiftSoundDefault } }

    func urlRequest(relativeTo baseURL: URL) throws -> URLRequest {
        guard let baseResolvedURL = URL(string: path, relativeTo: baseURL)?.absoluteURL,
              var components = URLComponents(url: baseResolvedURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL(path)
        }

        if !queryItems.isEmpty {
            components.queryItems = (components.queryItems ?? []) + queryItems
        }

        guard let url = components.url else {
            throw APIError.invalidURL(path)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers.forEach { field, value in
            request.setValue(value, forHTTPHeaderField: field)
        }

        if let body {
            request.httpBody = body.data
            if let contentType = body.contentType,
               request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
        }

        return request
    }
}
