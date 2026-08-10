//
//  RankingListViewModel.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import Foundation
import Combine

enum RankingCategory: String, CaseIterable, Identifiable {
    case recommendation = "榜单推荐"
    case official = "官方榜"
    case featured = "精选榜"
    case genre = "曲风榜"
    case global = "全球榜"
    case language = "语种榜"
    case special = "特色榜"

    var id: Self { self }

    var playlistIDs: [Int] {
        switch self {
        case .recommendation:
            return [
                1_9723_756,
                3_779_629,
                5_059_633_707,
                2_809_513_713,
                745_956_260,
                60_198
            ]
        case .official:
            return [1_9723_756, 3_779_629, 3_778_678, 2_884_035]
        case .featured:
            return [
                7_785_066_739,
                7_785_123_708,
                6_723_173_524,
                8_532_443_277,
                7_775_163_417
            ]
        case .genre:
            return [
                1_978_921_795,
                71_385_702,
                5_059_633_707,
                5_059_661_515,
                71_384_707,
                5_059_642_708,
                6_886_768_100
            ]
        case .global:
            return [60_198, 180_106, 60_131, 27_135_204, 6_939_992_364, 3_812_895]
        case .language:
            return [
                2_809_513_713,
                2_809_577_409,
                5_059_644_681,
                745_956_260,
                6_732_051_320,
                7_095_271_308,
                6_732_014_811
            ]
        case .special:
            return [7_603_212_484, 7_356_827_205, 6_688_069_460, 5_338_990_334]
        }
    }
}

struct RankingSection: Identifiable {
    let category: RankingCategory
    let playlists: [Playlist]

    var id: RankingCategory { category }
    var title: String { category.rawValue }
}

final class RankingListViewModel: ObservableObject {
    @Published private(set) var state: Loadable<[RankingSection]> = .idle

    private let repository: PlaylistsRepository

    init(repository: PlaylistsRepository = PlaylistsRepository()) {
        self.repository = repository
    }

    func load() async {
        if state.isLoading { return }
        state = .loading()

        do {
            let playlists = try await repository.fetchToplistDetails()
            state = .loaded(makeSections(from: playlists))
        } catch {
            state = .failed(error)
        }
    }
}

private extension RankingListViewModel {
    func makeSections(from playlists: [Playlist]) -> [RankingSection] {
        var playlistsByID = [Int: Playlist](minimumCapacity: playlists.count)
        for playlist in playlists {
            playlistsByID[playlist.id] = playlist
        }

        return RankingCategory.allCases.compactMap { category in
            let playlists = category.playlistIDs.compactMap { playlistsByID[$0] }
            guard !playlists.isEmpty else { return nil }
            return RankingSection(category: category, playlists: playlists)
        }
    }
}
