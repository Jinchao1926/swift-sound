//
//  MVDetailViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/5.
//

import AVFoundation
import Foundation
import Combine

final class MVDetailViewModel: ObservableObject {
    @Published private(set) var state: Loadable<MVDetail> = .idle
    @Published private(set) var urlState: Loadable<String> = .idle
    @Published private(set) var player: AVPlayer?

    private let id: Int
    private let repository: MVsRepository
    private var loadedPlayerURL: URL?

    // MARK: - LifeCycle
    init(
        id: Int,
        repository: MVsRepository = MVsRepository()
    ) {
        self.id = id
        self.repository = repository
    }

    func loadMV() async {
        async let load: () = load()
        async let urlLoad: () = loadURL()
        _ = await (load, urlLoad)
    }

    func load() async {
        guard !state.isLoadedOrLoading else { return }
        state = .loading()

        do {
            let mv = try await repository.fetchMVDetail(id: id)
            state = .loaded(mv)
        } catch {
            state = .failed(error)
        }
    }

    func loadURL() async {
        guard !urlState.isLoadedOrLoading else { return }
        urlState = .loading()

        do {
            let url = try await repository.fetchMVURL(id: id)
            urlState = .loaded(url)
            preparePlayer(from: url)
        } catch {
            urlState = .failed(error)
        }
    }

    func stopPlayer() {
        player?.pause()
    }

    private func preparePlayer(from rawURL: String) {
        guard let url = URL(string: rawURL)?.httpsURL,
              loadedPlayerURL != url else {
            return
        }

        player?.pause()
        player = AVPlayer(url: url)
        loadedPlayerURL = url
        player?.play()
    }
}
