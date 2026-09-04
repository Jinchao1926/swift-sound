//
//  UserDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import Foundation
import Combine

final class UserDetailViewModel: ObservableObject {
    @Published private(set) var playlistSelection = PlaylistSelection()
    @Published private(set) var radioDisplayMode = DisplayMode.grid

    @Published private(set) var state: Loadable<UserDetail> = .idle
    @Published private(set) var radioState: Loadable<Paginated<Radio>> = .idle
    @Published private(set) var radioCount: Int?
    @Published private var createdPlaylists = PlaylistCollection()
    @Published private var favoritePlaylists = PlaylistCollection()

    var selectedPlaylists: PlaylistCollection {
        collection(for: playlistSelection.tab)
    }

    private let id: Int
    private let repository: UsersRepository

    init(id: Int, repository: UsersRepository = UsersRepository()) {
        self.id = id
        self.repository = repository
    }

    // MARK: - Detail
    func load() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let detail = try await repository.fetchUserDetail(uid: id)
            state = .loaded(detail)
        } catch {
            state = .failed(error)
            return
        }

        await loadPlaylistPage(1)
    }

    // MARK: - Detail
    func loadRadios() async {
        guard !radioState.isLoadedOrLoading else { return }
        radioState = .loading()

        do {
            let response = try await repository.fetchUserRadios(uid: id)
            radioCount = response.count
            radioState = .loaded(Paginated(response))
        } catch {
            radioState = .failed(error)
        }
    }

    func updateRadioDisplayMode(_ displayMode: DisplayMode) {
        guard displayMode != radioDisplayMode else { return }
        radioDisplayMode = displayMode
    }

    // MARK: - Playlists
    func updatePlaylistSelection(_ action: PlaylistSelection.Action) async {
        switch action {
        case .tab(let tab):
            guard tab != playlistSelection.tab else { return }
            playlistSelection.apply(action)
            await loadPage(tab, page: 1)

        case .displayMode(let displayMode):
            guard displayMode != playlistSelection.displayMode else { return }
            playlistSelection.apply(action)
        }
    }

    func loadPlaylistPage(_ page: Int) async {
        await loadPage(playlistSelection.tab, page: page)
    }

    private func loadPage(_ tab: PlaylistTab, page: Int) async {
        guard let detail = state.value else { return }
        let createdCount = detail.profile.playlistCount ?? 0
        guard page > 0, page <= pageCount(for: tab, createdCount: createdCount) else { return }

        var collection = collection(for: tab)
        guard !collection.state.isLoading else { return }

        if let cachedPage = collection.pages[page] {
            collection.show(cachedPage, page: page)
            update(collection, for: tab)
            return
        }

        let previousPage = collection.state.value
        let loadedPage = collection.currentPage
        collection.state = .loading(previousPage)
        collection.currentPage = page
        update(collection, for: tab)

        do {
            let pageValue = try await fetchPlaylists(tab, page: page, createdCount: createdCount)
            collection.store(pageValue, page: page)
        } catch {
            collection.currentPage = loadedPage
            collection.state = previousPage.map { .loaded($0) } ?? .failed(error)
        }
        update(collection, for: tab)
    }

    private func fetchPlaylists(
        _ tab: PlaylistTab,
        page: Int,
        createdCount: Int
    ) async throws -> Paginated<Playlist> {
        let response = try await repository.fetchUserPlaylists(
            uid: id,
            offset: tab.offset(page: page, createdCount: createdCount),
            limit: PlaylistPagination.pageSize
        )

        switch tab {
        case .created:
            // 创建歌单最后一页可能跨过区间边界，用 creator 过滤掉混入的收藏歌单
            return Paginated(
                items: response.items.filter { $0.creator.id == id },
                canLoadMore: page < pageCount(for: .created, createdCount: createdCount)
            )
        case .favorite:
            return Paginated(response)
        }
    }

    private func pageCount(for tab: PlaylistTab, createdCount: Int) -> Int {
        switch tab {
        case .created:
            return max(1, (createdCount + PlaylistPagination.pageSize - 1) / PlaylistPagination.pageSize)
        case .favorite:
            return favoritePlaylists.pageCount
        }
    }

    private func collection(for tab: PlaylistTab) -> PlaylistCollection {
        switch tab {
        case .created: return createdPlaylists
        case .favorite: return favoritePlaylists
        }
    }

    private func update(_ collection: PlaylistCollection, for tab: PlaylistTab) {
        switch tab {
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
    }
}

private enum PlaylistPagination {
    static let pageSize = 20
}

private extension PlaylistTab {
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
