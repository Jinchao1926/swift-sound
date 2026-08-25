//
//  UserDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import Foundation
import Combine

final class UserDetailViewModel: ObservableObject {
    @Published private(set) var state: Loadable<UserDetail> = .idle
    @Published private(set) var createdPlaylists = PlaylistCollection()
    @Published private(set) var favoritePlaylists = PlaylistCollection()

    private let id: Int
    private let repository: UsersRepository

    init(id: Int, repository: UsersRepository = UsersRepository()) {
        self.id = id
        self.repository = repository
    }

    func load() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        let detail: UserDetail
        do {
            detail = try await repository.fetchUserDetail(uid: id)
            state = .loaded(detail)
        } catch {
            state = .failed(error)
            return
        }

        createdPlaylists.state = .loading()
        favoritePlaylists.state = .loading()

        let createdCount = detail.profile.playlistCount ?? 0

        // 创建和收藏歌单互不依赖，用户详情返回后并发获取两组第一页。
        async let createdResult = fetchResult(.created, page: 1, createdCount: createdCount)
        async let favoriteResult = fetchResult(.favorite, page: 1, createdCount: createdCount)
        let (createdPageResult, favoritePageResult) = await (createdResult, favoriteResult)

        createdPlaylists.store(createdPageResult, page: 1)
        favoritePlaylists.store(favoritePageResult, page: 1)
    }

    func loadCreated(page: Int) async {
        await loadPage(.created, page: page)
    }

    func loadFavorite(page: Int) async {
        await loadPage(.favorite, page: page)
    }

    private func loadPage(_ section: PlaylistSection, page: Int) async {
        guard let detail = state.value else { return }
        let createdCount = detail.profile.playlistCount ?? 0
        guard page > 0, page <= pageCount(for: section, createdCount: createdCount) else { return }

        var collection = collection(for: section)
        guard !collection.state.isLoading else { return }

        if let cachedPage = collection.pages[page] {
            collection.show(cachedPage, page: page)
            update(collection, for: section)
            return
        }

        let previousPage = collection.state.value
        let loadedPage = collection.currentPage
        collection.state = .loading(previousPage)
        collection.currentPage = page
        update(collection, for: section)

        do {
            let pageValue = try await fetchPlaylists(section, page: page, createdCount: createdCount)
            collection.store(pageValue, page: page)
        } catch {
            collection.currentPage = loadedPage
            collection.state = previousPage.map { .loaded($0) } ?? .failed(error)
        }
        update(collection, for: section)
    }

    private func fetchResult(
        _ section: PlaylistSection,
        page: Int,
        createdCount: Int
    ) async -> Result<Paginated<Playlist>, Error> {
        do {
            let response = try await fetchPlaylists(section, page: page, createdCount: createdCount)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }

    private func fetchPlaylists(
        _ section: PlaylistSection,
        page: Int,
        createdCount: Int
    ) async throws -> Paginated<Playlist> {
        let response = try await repository.fetchUserPlaylists(
            uid: id,
            offset: section.offset(page: page, createdCount: createdCount),
            limit: PlaylistPagination.pageSize
        )

        switch section {
        case .created:
            // 创建歌单最后一页可能跨过区间边界，用 creator 过滤掉混入的收藏歌单。
            return Paginated(
                items: response.items.filter { $0.creator.id == id },
                canLoadMore: page < pageCount(for: .created, createdCount: createdCount)
            )
        case .favorite:
            return Paginated(response)
        }
    }

    private func pageCount(for section: PlaylistSection, createdCount: Int) -> Int {
        switch section {
        case .created:
            return max(1, (createdCount + PlaylistPagination.pageSize - 1) / PlaylistPagination.pageSize)
        case .favorite:
            return favoritePlaylists.pageCount
        }
    }

    private func collection(for section: PlaylistSection) -> PlaylistCollection {
        switch section {
        case .created: return createdPlaylists
        case .favorite: return favoritePlaylists
        }
    }

    private func update(_ collection: PlaylistCollection, for section: PlaylistSection) {
        switch section {
        case .created: createdPlaylists = collection
        case .favorite: favoritePlaylists = collection
        }
    }
}

extension UserDetailViewModel {
    struct PlaylistCollection {
        fileprivate(set) var state: Loadable<Paginated<Playlist>> = .idle
        fileprivate(set) var currentPage = 1
        fileprivate var pages: [Int: Paginated<Playlist>] = [:]

        var pageCount: Int {
            let lastPage = pages.keys.max() ?? 0
            guard lastPage > 0 else { return 1 }
            return lastPage + (pages[lastPage]?.canLoadMore == true ? 1 : 0)
        }

        fileprivate mutating func show(_ pageValue: Paginated<Playlist>, page: Int) {
            currentPage = page
            state = .loaded(pageValue)
        }

        fileprivate mutating func store(_ pageValue: Paginated<Playlist>, page: Int) {
            pages[page] = pageValue
            show(pageValue, page: page)
        }

        fileprivate mutating func store(
            _ result: Result<Paginated<Playlist>, Error>,
            page: Int
        ) {
            switch result {
            case .success(let pageValue):
                store(pageValue, page: page)
            case .failure(let error):
                state = .failed(error)
            }
        }
    }
}

private extension UserDetailViewModel {
    enum PlaylistSection {
        case created
        case favorite

        func offset(page: Int, createdCount: Int) -> Int {
            switch self {
            case .created:
                return (page - 1) * PlaylistPagination.pageSize
            case .favorite:
                // 此接口从 playlistCount - 1 开始返回收藏歌单，后续按每页数量递增。
                return max(0, createdCount - 1) + (page - 1) * PlaylistPagination.pageSize
            }
        }
    }

    enum PlaylistPagination {
        static let pageSize = 20
    }
}
