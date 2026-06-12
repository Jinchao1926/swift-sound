//
//  APIClient.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Alamofire
import Foundation

final class APIClient: APIClientProtocol {
    private let configuration: AppConfiguration
    private let session: Session
    private let cache: APIResponseCache

    init(
        configuration: AppConfiguration = .current(),
        session: Session = .default,
        cache: APIResponseCache = .shared
    ) {
        self.configuration = configuration
        self.session = session
        self.cache = cache
    }

    func request<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        // 1. Cache
        let cacheKey = request.cacheKey(relativeTo: configuration.baseURL)
        if let value = cache.value(for: cacheKey, as: Request.Response.self) {
            return value
        }

        // 2. Network
        let urlRequest = try request.urlRequest(relativeTo: configuration.baseURL)

        let value: Request.Response = try await withCheckedThrowingContinuation { continuation in
            session
                .request(urlRequest)
                .validate()
                .responseDecodable(of: Request.Response.self, decoder: request.decoder) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        let statusCode = response.response?.statusCode
                        let message = response.data.flatMap { String(data: $0, encoding: .utf8) }
                        continuation.resume(
                            throwing: APIError.requestFailed(
                                statusCode: statusCode,
                                message: message,
                                underlying: error
                            )
                        )
                    }
                }
        }

        cache.store(value, for: cacheKey, policy: request.cachePolicy)
        return value
    }
}
