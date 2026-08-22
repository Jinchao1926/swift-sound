//
//  NewAlbumsViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/21.
//

import Foundation
import Combine

struct TopAlbumsSelection: Hashable {
    let area: TopAlbumsArea
    let type: TopAlbumsType

    init(area: TopAlbumsArea = .all, type: TopAlbumsType = .hot) {
        self.area = area
        self.type = type
    }
}

final class NewAlbumsViewModel: ObservableObject {
    @Published var selection = TopAlbumsSelection()
    @Published private(set) var state: Loadable<TopAlbums> = .idle

    private let repository: AlbumsRepository

    init(repository: AlbumsRepository = AlbumsRepository()) {
        self.repository = repository
    }

    func load() async {
        let request = selection
        state = .loading()

        do {
            let albums = try await repository.fetchTopAlbums(area: request.area, type: request.type)
            guard isCurrentSelection(request) else { return }
            state = .loaded(albums)
        } catch {
            guard isCurrentSelection(request) else { return }
            state = .failed(error)
        }
    }

    func updateSelection(area: TopAlbumsArea? = nil, type: TopAlbumsType? = nil) {
        let newArea = area ?? selection.area
        let newType = type ?? selection.type
        selection = TopAlbumsSelection(area: newArea, type: newType)
    }
}

private extension NewAlbumsViewModel {
    func isCurrentSelection(_ requestSelecton: TopAlbumsSelection) -> Bool {
        !Task.isCancelled && requestSelecton == selection
    }
}
