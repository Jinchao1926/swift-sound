//
//  UsersRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/22.
//

import Foundation

struct UsersRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchUserDetail(id: Int) async throws -> UserDetail {
        let response = try await apiClient.request(UserDetailRequest(id: id))
        return response
    }
}
