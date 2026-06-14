//
//  HeroBannerViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation
import Combine

final class HeroBannerViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([Banner])
        case failed(Error)

        var banners: [Banner] {
            if case let .loaded(banners) = self {
//                if banners.count % 2 == 1 {
//                    var temp = banners
//                    temp.remove(at: Int.random(in: 0..<temp.count))
//                    return temp
//                }
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
