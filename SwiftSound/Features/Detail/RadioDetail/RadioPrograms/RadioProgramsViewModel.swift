//
//  RadioProgramsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation
import Combine

final class RadioProgramsViewModel: ObservableObject {
    @Published private(set) var state: Loadable<Paginated<Program>> = .idle
    @Published var searchText = ""

    private let id: Int
    private let repository: RadiosRepositoryProtocol
    private var pages: [Int: Paginated<Program>] = [:]
    private var ascending = false

    private(set) var currentPage = 1
    private(set) var totalCount: Int?

    var programs: [Program] {
        let programs = state.items
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !keyword.isEmpty else { return programs }

        return programs.filter {
            $0.name.range(
                of: keyword,
                options: [.caseInsensitive, .diacriticInsensitive]
            ) != nil
        }
    }

    var pageCount: Int {
        guard let totalCount else { return pages.isEmpty ? 1 : currentPage }
        return max(1, (totalCount + Pagination.pageSize - 1) / Pagination.pageSize)
    }

    // MARK: - LifeCycle
    init(id: Int, repository: RadiosRepositoryProtocol = RadiosRepository()) {
        self.id = id
        self.repository = repository
    }

    // MARK: - Requests
    func load() async {
        await load(page: 1)
    }

    func load(page: Int) async {
        guard page > 0, page <= pageCount else { return }
        guard !state.isLoading else { return }

        if let cachedPage = pages[page] {
            currentPage = page
            state = .loaded(cachedPage)
            return
        }

        let previousPage = currentPage
        let previousValue = state.value
        currentPage = page
        state = .loading()

        do {
            let response = try await repository.fetchRadioPrograms(
                id: id,
                offset: (page - 1) * Pagination.pageSize,
                limit: Pagination.pageSize,
                asc: ascending
            )
            let pageValue = Paginated(response)
            totalCount = response.count
            pages[page] = pageValue
            state = .loaded(pageValue)
        } catch {
            currentPage = previousPage
            state = previousValue.map { .loaded($0) } ?? .failed(error)
        }
    }

    func updateSort(asc: Bool) async {
        guard asc != ascending else { return }
        ascending = asc
        pages.removeAll()
        currentPage = 1
        state = .idle
        await load()
    }
}

private enum Pagination {
    static let pageSize = 100
}
