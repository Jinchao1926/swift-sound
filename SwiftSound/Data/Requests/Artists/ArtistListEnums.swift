//
//  ArtistListEnums.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/23.
//

import Foundation

enum ArtistType: Int, CaseIterable, Identifiable {
    case all = -1   // 全部
    case male = 1   // 男歌手
    case female = 2 // 女歌手
    case group = 3  // 乐队

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .all:
            return "全部"
        case .male:
            return "男歌手"
        case .female:
            return "女歌手"
        case .group:
            return "乐队组合"
        }
    }
}

enum ArtistArea: Int, CaseIterable, Identifiable {
    case all = -1       // 全部
    case chinese = 7    // 华语
    case western = 96   // 欧美
    case japanese = 8   // 日本
    case korean = 16    // 韩国
    case other = 0      // 其他

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .all:
            return "全部"
        case .chinese:
            return "华语"
        case .western:
            return "欧美"
        case .japanese:
            return "日本"
        case .korean:
            return "韩国"
        case .other:
            return "其他"
        }
    }
}

enum ArtistInitial: Equatable, Identifiable {
    case hot
    case other
    case letter(Character)

    init?(rawValue: Int) {
        switch rawValue {
        case -1:
            self = .hot
        case 0:
            self = .other
        case 65...90:
            self.init(rawValue: rawValue + 32)
        case 97...122:
            guard let scalar = UnicodeScalar(rawValue) else {
                return nil
            }
            self = .letter(Character(scalar))
        default:
            return nil
        }
    }

    init?(rawValue: String) {
        let normalizedValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if let intValue = Int(normalizedValue) {
            self.init(rawValue: intValue)
            return
        }

        guard normalizedValue.unicodeScalars.count == 1,
              let scalar = normalizedValue.unicodeScalars.first,
              (97...122).contains(Int(scalar.value)) else {
            return nil
        }

        self = .letter(Character(scalar))
    }

    var id: String { queryValue }

    var queryValue: String {
        switch self {
        case .hot:
            return "-1"
        case .other:
            return "0"
        case .letter(let character):
            return String(character).lowercased()
        }
    }

    var title: String {
        switch self {
        case .hot:
            return "热门"
        case .other:
            return "#"
        case .letter(let character):
            return String(character).uppercased()
        }
    }

    static var allCases: [ArtistInitial] {
        [.hot] + Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map { ArtistInitial.letter($0) } + [.other]
    }
}
