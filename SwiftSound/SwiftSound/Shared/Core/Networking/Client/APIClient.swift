//
//  APIClient.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Alamofire
import Foundation

final class APIClient: APIClientProtocol, @unchecked Sendable {
    private let configuration: AppConfiguration
    private let session: Session

    init(
        configuration: AppConfiguration = .current(),
        session: Session = .default
    ) {
        self.configuration = configuration
        self.session = session
    }

    func request<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let urlRequest = try request.urlRequest(relativeTo: configuration.baseURL)

        return try await withCheckedThrowingContinuation { continuation in
            session
                .request(urlRequest)
                .validate()
                .responseDecodable(of: Request.Response.self, decoder: request.decoder()) { response in
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
    }
}
