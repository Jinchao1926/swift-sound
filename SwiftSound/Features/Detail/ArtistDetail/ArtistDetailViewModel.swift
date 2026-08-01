//
//  ArtistDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/27.
//

import Foundation
import Combine

final class ArtistDetailViewModel: ObservableObject {
    @Published private(set) var state: Loadable<ArtistDetail> = .idle
    @Published private(set) var songsState: Loadable<[Song]> = .idle
    @Published private(set) var albumState: Loadable<Paginated<Album>> = .idle
    @Published private(set) var profileState: Loadable<ArtistDesc> = .idle

    private let id: Int
    private let repository: ArtistsRepository

    // MARK: - LifeCycle
    init(id: Int, repository: ArtistsRepository = ArtistsRepository()) {
        self.id = id
        self.repository = repository
    }

    func load() async {
        // 详情数据按歌手维度保持稳定，避免切换子 tab 或返回页面时重新进入 loading 导致 header 闪烁
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let artist = try await repository.fetchArtistDetail(id: id)
            state = .loaded(artist)
        } catch {
            state = .failed(error)
        }
    }

    func loadPopularSongs() async {
        guard !songsState.isLoadedOrLoading else { return }
        songsState = .loading()

        do {
            let data = try await repository.fetchArtistPopularSongs(id: id)
            songsState = .loaded(data)
        } catch {
            songsState = .failed(error)
        }
    }

    func loadAlbums() async {
        guard !albumState.isLoadedOrLoading else { return }
        albumState = .loading()

        do {
            let response = try await repository.fetchArtistAlbums(id: id)
            albumState = .loaded(Paginated(response))
        } catch {
            albumState = .failed(error)
        }
    }

    func loadMoreAlbums() async {
        guard var page = albumState.value, page.canLoadMore else { return }
        albumState = .loading(page)

        do {
            let response = try await repository.fetchArtistAlbums(id: id, offset: page.nextOffset)
            page.append(response)
            albumState = .loaded(page)
        } catch {
            albumState = .loaded(page)
        }
    }

    func loadProfile() async {
        guard !profileState.isLoadedOrLoading else { return }
        profileState = .loading()

        do {
            let data = try await repository.fetchArtistDesc(id: id)
            profileState = .loaded(data)
        } catch {
            profileState = .failed(error)
        }
    }
}

extension Loadable where Value == ArtistDetail {
    var artist: Artist? { value?.artist }
    var user: User? { value?.user }
}

extension Loadable where Value == ArtistDesc {
    var briefDesc: String { value?.briefDesc ?? "" }
    var introduction: [ArtistIntroduction] { value?.introduction ?? [] }
}
