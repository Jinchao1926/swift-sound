//
//  MVsRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/5.
//

import Foundation

struct MVsRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchMVDetail(id: Int) async throws -> MVDetail {
        let response = try await apiClient.request(MVDetailRequest(id: id))
        return response.data
    }

    func fetchMVURL(id: Int) async throws -> String {
        let response = try await apiClient.request(MVURLRequest(id: id))
        return response.data.url
    }
}
