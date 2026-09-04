//
//  AlbumsRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/3.
//

import Foundation

protocol AlbumsRepositoryProtocol {
    func fetchTopAlbums(area: TopAlbumsArea, type: TopAlbumsType, year: Int?, month: Int?) async throws -> TopAlbums
    func fetchAlbumDetail(id: Int) async throws -> AlbumDetail
    func fetchAlbumDetailDynamic(id: Int) async throws -> AlbumDetailDynamic
}

extension AlbumsRepositoryProtocol {
    func fetchTopAlbums(area: TopAlbumsArea = .all, type: TopAlbumsType = .new, year: Int? = nil, month: Int? = nil) async throws -> TopAlbums {
        try await fetchTopAlbums(area: area, type: type, year: year, month: month)
    }
}

struct AlbumsRepository: AlbumsRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    // 新碟上架
    func fetchTopAlbums(
        area: TopAlbumsArea = .all,
        type: TopAlbumsType = .new,
        year: Int? = nil,
        month: Int? = nil
    ) async throws -> TopAlbums {
        let request = TopAlbumsRequest(area: area, type: type, year: year, month: month)
        let response = try await apiClient.request(request)
        return response
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
