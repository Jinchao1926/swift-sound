//
//  LyricsStore.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import Foundation
import Combine

final class LyricsStore: ObservableObject {
    @Published private var lyricStatesBySongId: [Song.ID: Loadable<[LyricLine]>] = [:]

    private let repository: SongsRespository
    private var loadingTasksBySongId: [Song.ID: Task<Void, Never>] = [:]

    init(repository: SongsRespository = SongsRespository()) {
        self.repository = repository
    }

    func lyricState(for songId: Song.ID) -> Loadable<[LyricLine]> {
        lyricStatesBySongId[songId] ?? .idle
    }

    func loadLyricsIfNeeded(for songId: Song.ID) {
        guard lyricStatesBySongId[songId]?.isLoadedOrLoading != true else {
            return
        }

        lyricStatesBySongId[songId] = .loading()

        loadingTasksBySongId[songId]?.cancel()
        loadingTasksBySongId[songId] = Task { [weak self, repository] in
            do {
                let lyrics = try await repository.fetchLyric(songId)
                guard !Task.isCancelled else { return }

                self?.setLoadedLyrics(lyrics, for: songId)
            } catch {
                guard !Task.isCancelled else { return }

                self?.setFailedLyrics(error, for: songId)
            }
        }
    }
}

private extension LyricsStore {
    func setLoadedLyrics(_ lyrics: [LyricLine], for songId: Song.ID) {
        loadingTasksBySongId[songId] = nil
        lyricStatesBySongId[songId] = .loaded(lyrics)
    }

    func setFailedLyrics(_ error: Error, for songId: Song.ID) {
        loadingTasksBySongId[songId] = nil
        lyricStatesBySongId[songId] = .failed(error)
    }
}

#if DEBUG
extension LyricsStore {
    static func preview(
        song: Song = .preview,
        lyric: Lyric = .preview
    ) -> LyricsStore {
        let store = LyricsStore()
        store.lyricStatesBySongId[song.id] = .loaded(LyricParser.parse(lyric.lyric))
        return store
    }
}
#endif
