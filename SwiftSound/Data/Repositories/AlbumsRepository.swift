//
//  AlbumsRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/3.
//

import Foundation

struct AlbumsRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchAlbumDetail(id: Int) async throws -> AlbumDetail {
        let response = try await apiClient.request(AlbumDetailRequest(id: id))
        return response
    }

    func fetchAlbumDetailDynamic(id: Int) async throws -> AlbumDetailDynamic {
        let response = try await apiClient.request(AlbumDetailDynamicRequest(id: id))
        return response.dynamic
    }
}
