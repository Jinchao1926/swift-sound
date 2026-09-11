//
//  ProgramsRepository.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation

protocol ProgramsRepositoryProtocol {
    func fetchProgramsChartsDaily() async throws -> [ProgramChart]
    func fetchProgramsChartsFeatured() async throws -> [ProgramChart]
}

struct ProgramsRepository: ProgramsRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchProgramsChartsDaily() async throws -> [ProgramChart] {
        let response = try await apiClient.request(ProgramsChartsDailyRequest())
        return response.data.list
    }

    func fetchProgramsChartsFeatured() async throws -> [ProgramChart] {
        let response = try await apiClient.request(ProgramsChartsRequest())
        return response.toplist
    }
}
