//
//  RadiosRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import Foundation

protocol RadiosRepositoryProtocol {
    // MARK: - Categories
    func fetchRadioCategories() async throws -> [RadioCategory]

    // MARK: - Hosts
    func fetchRadioHostChartsDaily() async throws -> [RadioHostChart]
    func fetchRadioHostChartsNewComer() async throws -> [RadioHostChart]
    func fetchRadioHostChartsPopular() async throws -> [RadioHostChart]

    // MARK: - Radios
    func fetchRadioChartsPopular() async throws -> [RadioChart]
    func fetchRadioChartsNewComer() async throws -> [RadioChart]
    func fetchRadioChartsPaid() async throws -> [RadioPaidChart]
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
    func fetchRadioHostChartsDaily() async throws -> [RadioHostChart] {
        let response = try await apiClient.request(RadioHostChartsDailyRequest())
        return response.data.list
    }

    func fetchRadioHostChartsNewComer() async throws -> [RadioHostChart] {
        let response = try await apiClient.request(RadioHostChartsNewComerRequest())
        return response.data.list
    }

    func fetchRadioHostChartsPopular() async throws -> [RadioHostChart] {
        let response = try await apiClient.request(RadioHostChartsPopularRequest())
        return response.data.list
    }

    // MARK: - Radios
    func fetchRadioChartsPopular() async throws -> [RadioChart] {
        let response = try await apiClient.request(RadioChartsRequest(type: .hot))
        return response.toplist
    }

    func fetchRadioChartsNewComer() async throws -> [RadioChart] {
        let response = try await apiClient.request(RadioChartsRequest(type: .new))
        return response.toplist
    }

    func fetchRadioChartsPaid() async throws -> [RadioPaidChart] {
        let response = try await apiClient.request(RadioChartsPaidRequest())
        return response.data.list
    }
}
