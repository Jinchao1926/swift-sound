//
//  APIRequest.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Foundation

/// Describes one typed API request.
///
/// Feature modules define small request structs that provide the route,
/// parameters, optional body, and expected response type. `APIClient` owns the
/// actual transport implementation.
nonisolated protocol APIRequest {
    associatedtype Response: Decodable

    var path: String { get }
    var method: APIHTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var body: APIRequestBody? { get }
    var cachePolicy: APICachePolicy { get }
    var decoder: JSONDecoder { get }
}

extension APIRequest {
    var method: APIHTTPMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    var body: APIRequestBody? { nil }
    var cachePolicy: APICachePolicy { .none }
    var decoder: JSONDecoder { .swiftSoundDefault }
}

nonisolated extension APIRequest {
    /// Builds the concrete URLRequest.
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

    /// Cache key used by APIResponseCache.
    ///
    /// GET requests are keyed by method and resolved URL. Requests with a body
    /// include encoded body data so distinct payloads do not collide.
    func cacheKey(relativeTo baseURL: URL) -> String {
        guard cachePolicy.isEnabled else {
            return ""
        }

        let url = (try? urlRequest(relativeTo: baseURL).url?.absoluteString) ?? path
        var components = [method.rawValue, url]

        if let body {
            components.append(body.data.base64EncodedString())
        }

        return components.joined(separator: " ")
    }
}
