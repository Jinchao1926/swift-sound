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
    @Published private(set) var profileState: Loadable<ArtistDesc> = .idle

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

    // MARK: - Profile
//    func loadProfile() async {
//        guard !profileState.isLoadedOrLoading else { return }
//        profileState = .loading()
//
//        do {
//            let data = try await repository.fetchArtistDesc(id: id)
//            profileState = .loaded(data)
//        } catch {
//            profileState = .failed(error)
//        }
//    }
}

extension Loadable where Value == AlbumDetail {
    var album: Album? { value?.album }
    var songs: [Song] { value?.songs ?? [] }
}
