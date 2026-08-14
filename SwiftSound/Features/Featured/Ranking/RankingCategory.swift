//
//  RankingCategory.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/10.
//

import Foundation

enum RankingCategory: String, CaseIterable, Hashable, Identifiable {
    case recommendation = "榜单推荐"
    case official = "官方榜"
    case featured = "精选榜"
    case genre = "曲风榜"
    case global = "全球榜"
    case language = "语种榜"
    case special = "特色榜"

    var id: Self { self }

    var toplistIDs: [Int] {
        switch self {
        case .recommendation:
            return [
                991_319_590,
                5_059_661_515,
                5_059_642_708,
                5_059_633_707,
                2_809_513_713,
                745_956_260
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

    func displayTitle(for toplist: Toplist) -> String {
        guard self == .global else {
            return toplist.name.replacingOccurrences(of: "网易云", with: "")
        }

        switch toplist.id {
        case 60_198:
            return "美国公告牌榜"
        case 180_106:
            return "英国UK榜"
        case 60_131:
            return "日本公信榜"
        case 27_135_204:
            return "法国NRJ榜"
        case 6_939_992_364:
            return "俄罗斯流行榜"
        case 3_812_895:
            return "全球电子舞曲榜"
        default:
            return toplist.name.replacingOccurrences(of: "网易云", with: "")
        }
    }
}

struct RankingSection: Identifiable {
    let category: RankingCategory
    let toplists: [Toplist]

    var id: RankingCategory { category }
    var title: String { category.rawValue }
}
