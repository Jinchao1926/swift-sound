//
//  HeroBannerViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation
import Combine

final class HeroBannersViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([Banner])
        case failed(Error)

        var banners: [Banner] {
            if case let .loaded(banners) = self {
                return banners
            }
            return []
        }
    }

    @Published private(set) var state: State = .idle

    private let repository: BannersRepository

    init(repository: BannersRepository = BannersRepository()) {
        self.repository = repository
    }

    func load() async {
        if case .loading = state { return }
        state = .loading

        do {
            let banners = try await repository.fetchBanners()
            state = .loaded(banners)
        } catch {
            state = .failed(error)
        }
    }
}
