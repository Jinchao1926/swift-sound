//
//  HeroBannerViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/14.
//

import Foundation
import Combine

final class HeroBannerViewModel: ObservableObject {
    @Published private(set) var banners: [Banner] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let repository: BannersRepository

    init(repository: BannersRepository = BannersRepository()) {
        self.repository = repository
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }

        debugPrint("HeroBannerViewModel load")
        do {
            banners = try await repository.fetchBanners()
            error = nil
        } catch {
            banners = []
            self.error = error
        }
    }
}
