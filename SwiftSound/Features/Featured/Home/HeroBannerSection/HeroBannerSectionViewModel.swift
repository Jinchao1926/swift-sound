//
//  HeroBannerSectionViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation
import Combine

final class HeroBannerSectionViewModel: ObservableObject {
    @Published private(set) var state: Loadable<[Banner]> = .idle

    private let repository: BannersRepositoryProtocol

    init(repository: BannersRepositoryProtocol = BannersRepository()) {
        self.repository = repository
    }

    func load() async {
        if state.isLoading { return }
        state = .loading()

        do {
            let banners = try await repository.fetchBanners()
            state = .loaded(banners)
        } catch {
            state = .failed(error)
        }
    }
}
