//
//  RadiosRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import Foundation

protocol RadiosRepositoryProtocol {
    func fetchRadioCategories() async throws -> [RadioCategory]

    func fetchRadioHostChartsDaily() async throws -> [RadioHost]
    func fetchRadioHostChartsNewComer() async throws -> [RadioHost]
    func fetchRadioHostChartsPopular() async throws -> [RadioHost]
}

struct RadiosRepository: RadiosRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - Categories
    func fetchRadioCategories() async throws -> [RadioCategory] {
        let response = try await apiClient.request(RadioCategoriesRequest())
        return response.categories
    }

    // MARK: - Hosts
    func fetchRadioHostChartsDaily() async throws -> [RadioHost] {
        let response = try await apiClient.request(RadioHostChartsDailyRequest())
        return response.data.list
    }

    func fetchRadioHostChartsNewComer() async throws -> [RadioHost] {
        let response = try await apiClient.request(RadioHostChartsNewComerRequest())
        return response.data.list
    }

    func fetchRadioHostChartsPopular() async throws -> [RadioHost] {
        let response = try await apiClient.request(RadioHostChartsPopularRequest())
        return response.data.list
    }
}
