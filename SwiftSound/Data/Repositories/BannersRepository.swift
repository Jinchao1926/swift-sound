//
//  BannersRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation

protocol BannersRepositoryProtocol {
    func fetchBanners() async throws -> [Banner]
}

struct BannersRepository: BannersRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchBanners() async throws -> [Banner] {
        let response = try await apiClient.request(BannersRequest())
        return response.banners
    }
}
