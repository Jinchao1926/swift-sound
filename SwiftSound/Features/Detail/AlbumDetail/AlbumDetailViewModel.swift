//
//  AlbumDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/6.
//

import Foundation
import Combine

final class AlbumDetailViewModel: ObservableObject {
    @Published private(set) var state: Loadable<AlbumDetail> = .idle
    @Published private(set) var dynamicState: Loadable<AlbumDetailDynamic> = .idle

    private let id: Int
    private let repository: AlbumsRepository

    // MARK: - LifeCycle
    init(
        id: Int,
        repository: AlbumsRepository = AlbumsRepository()
    ) {
        self.id = id
        self.repository = repository
    }

    func loadAlbum() async {
        async let load: () = load()
        async let loadDynamic: () = loadDynamic()
        _ = await (load, loadDynamic)
    }

    func load() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let album = try await repository.fetchAlbumDetail(id: id)
            state = .loaded(album)
        } catch {
            state = .failed(error)
        }
    }

    func loadDynamic() async {
        guard !dynamicState.isLoadedOrLoading else { return }
        dynamicState = .loading()

        do {
            let data = try await repository.fetchAlbumDetailDynamic(id: id)
            dynamicState = .loaded(data)
        } catch {
            dynamicState = .failed(error)
        }
    }
}

extension Loadable where Value == AlbumDetail {
    var album: Album? { value?.album }
    var songs: [Song] { value?.songs ?? [] }
}
