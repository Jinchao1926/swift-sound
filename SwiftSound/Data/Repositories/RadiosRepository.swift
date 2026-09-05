//
//  RadiosRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import Foundation

protocol RadiosRepositoryProtocol {
    func fetchRadioCategories() async throws -> [RadioCategory]
}

struct RadiosRepository: RadiosRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchRadioCategories() async throws -> [RadioCategory] {
        let response = try await apiClient.request(RadioCategoriesRequest())
        return response.categories
    }
}
