//
//  AlbumRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/3.
//

import Foundation

struct AlbumRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchAlbumDetail(id: Int) async throws -> AlbumDetailResponse {
        let response = try await apiClient.request(AlbumDetailRequest(id: id))
        return response
    }
}
