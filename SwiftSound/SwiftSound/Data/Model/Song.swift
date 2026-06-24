//
//  Song.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation

/**
 * 付费类型 - 歌曲付费/权限状态
 * 表示歌曲是否需要 VIP 会员或购买
 */
enum FeeType: Int, Decodable {
    /** 免费 - 无需付费，所有用户可播放 */
    case free = 0
    /** VIP 专享 - 需要 VIP 会员才能播放 */
    case vip = 1
    /** 需购买专辑 - 需要购买专辑才能播放 */
    case albumPurchase = 4
    /** 限时免费 - 非会员可播放低音质，VIP 可播放高音质 */
    case limitedFree = 8
}

enum OriginCoverType: Int, Decodable {
    case none = 0
    case originalTrack = 1  // 原版原唱录音
    case fullCover = 2      // 完整翻唱
    case remixAdapt = 3     // Remix/采样/改编衍生曲

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        self = OriginCoverType(rawValue: rawValue) ?? .none
    }
}

struct SongPrivilege: Decodable {
    struct ChargeInfo: Decodable {
        let rate: Int
        // 是否收费
        let chargeType: Int?
    }

    let chargeInfoList: [ChargeInfo]
}

struct Song: Decodable, Identifiable {
    let id: Int
    let name: String
    // 时长，毫秒
    let duration: Int
    // 歌手信息
    let artists: [Artist]
    // 专辑信息
    let album: Album
    // Track Name Supplement - 曲目名称补充
    let tns: [String]?
    let aliases: [String]
    let mvId: Int
    // 付费类型，参考 FeeType 枚举
    let fee: FeeType?
    // 用于表示各种曲目属性（VIP、独家、高品质等）的位标志
    let mark: Int?
    // 原唱/翻唱
    let originCoverType: OriginCoverType
    let privilege: SongPrivilege?

    init(
        id: Int,
        name: String,
        duration: Int,
        artists: [Artist],
        album: Album,
        tns: [String]?,
        aliases: [String],
        mvId: Int,
        fee: FeeType?,
        mark: Int?,
        originCoverType: OriginCoverType,
        privilege: SongPrivilege?
    ) {
        self.id = id
        self.name = name
        self.duration = duration
        self.artists = artists
        self.album = album
        self.tns = tns
        self.aliases = aliases
        self.mvId = mvId
        self.fee = fee
        self.mark = mark
        self.originCoverType = originCoverType
        self.privilege = privilege
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case duration
        case dt
        case artists
        case ar
        case album
        case al
        case tns
        case aliases
        case alias
        case alia
        case mvId
        case mv
        case mvid
        case fee
        case mark
        case originCoverType
        case privilege
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        duration = try container.decodeIfPresent(Int.self, forKey: .duration)
            ?? container.decode(Int.self, forKey: .dt)
        artists = try container.decodeIfPresent([Artist].self, forKey: .artists)
            ?? container.decode([Artist].self, forKey: .ar)
        album = try container.decodeIfPresent(Album.self, forKey: .album)
            ?? container.decode(Album.self, forKey: .al)
        tns = try container.decodeIfPresent([String].self, forKey: .tns)
        aliases = try container.decodeIfPresent([String].self, forKey: .aliases)
            ?? container.decodeIfPresent([String].self, forKey: .alias)
            ?? container.decodeIfPresent([String].self, forKey: .alia)
            ?? []
        mvId = try container.decodeIfPresent(Int.self, forKey: .mvId)
            ?? container.decodeIfPresent(Int.self, forKey: .mvid)
            ?? container.decodeIfPresent(Int.self, forKey: .mv)
            ?? 0
        fee = try container.decodeIfPresent(FeeType.self, forKey: .fee)
        mark = try container.decodeIfPresent(Int.self, forKey: .mark)
        originCoverType = try container.decodeIfPresent(OriginCoverType.self, forKey: .originCoverType) ?? .none
        privilege = try container.decodeIfPresent(SongPrivilege.self, forKey: .privilege)
    }
}

extension Song {
    var durationTimeInterval: TimeInterval {
        TimeInterval(duration) / 1000
    }

    var artistName: String? {
        let names = artists.map(\.name).filter { !$0.isEmpty }
        guard !names.isEmpty else { return nil }
        return names.joined(separator: " / ")
    }

    // VIP
    var requiresVIP: Bool { fee == .vip }

    // MV
    var hasMV: Bool { mvId != 0 }

    // 原唱
    var hasOriginalBadge: Bool { originCoverType == .originalTrack }
    var isHiRes: Bool {
        privilege?.chargeInfoList.contains { $0.rate == 1_999_000 } == true
    }
}
