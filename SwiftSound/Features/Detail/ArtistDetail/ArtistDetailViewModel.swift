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

    private let id: Int
    private let repository: ArtistsRepository

    // MARK: - LifeCycle
    init(id: Int, repository: ArtistsRepository = ArtistsRepository()) {
        self.id = id
        self.repository = repository
    }

    func load() async {
        // 详情数据按歌手维度保持稳定，避免切换子 tab 或返回页面时重新进入 loading 导致 header 闪烁。
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let artist = try await repository.fetchArtistDetail(id: id)
            state = .loaded(artist)
        } catch {
            state = .failed(error)
        }
    }
}

extension Loadable where Value == ArtistDetail {
    var artist: Artist? { value?.artist }

    var user: User? { value?.user }
}
