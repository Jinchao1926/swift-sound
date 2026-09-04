//
//  UsersRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/22.
//

import Foundation

protocol UsersRepositoryProtocol {
    func fetchUserDetail(uid: Int) async throws -> UserDetail
    func fetchUserPlaylists(uid: Int, offset: Int, limit: Int) async throws -> UserPlaylistsResponse
    func fetchUserRadios(uid: Int) async throws -> UserRadiosResponse
}

extension UsersRepositoryProtocol {
    func fetchUserPlaylists(uid: Int, offset: Int = 0, limit: Int = 24) async throws -> UserPlaylistsResponse { try await fetchUserPlaylists(uid: uid, offset: offset, limit: limit) }
}

struct UsersRepository: UsersRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchUserDetail(uid: Int) async throws -> UserDetail {
        let response = try await apiClient.request(UserDetailRequest(uid: uid))
        return response
    }

    func fetchUserPlaylists(
        uid: Int,
        offset: Int = 0,
        limit: Int = 24
    ) async throws -> UserPlaylistsResponse {
        let request = UserPlaylistsRequest(uid: uid, offset: offset, limit: limit)
        let response = try await apiClient.request(request)
        return response
    }

    func fetchUserRadios(uid: Int) async throws -> UserRadiosResponse {
        let request = UserRadiosRequest(uid: uid)
        let response = try await apiClient.request(request)
        return response
    }
}
