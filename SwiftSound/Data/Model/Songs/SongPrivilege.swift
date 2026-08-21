//
//  SongPrivilege.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/21.
//

import Foundation

struct SongPrivilege: Codable {
    struct ChargeInfo: Codable {
        let rate: Int
        // 是否收费
        let chargeType: Int?
    }

    let status: Int?
    let maxBrLevel: String?
    let chargeInfoList: [ChargeInfo]

    init(
        status: Int? = nil,
        maxBrLevel: String? = nil,
        chargeInfoList: [ChargeInfo]
    ) {
        self.status = status
        self.maxBrLevel = maxBrLevel
        self.chargeInfoList = chargeInfoList
    }

    private enum CodingKeys: String, CodingKey {
        case status = "st"
        case maxBrLevel
        case chargeInfoList
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        maxBrLevel = try container.decodeIfPresent(String.self, forKey: .maxBrLevel)
        chargeInfoList = try container.decodeIfPresent([ChargeInfo].self, forKey: .chargeInfoList) ?? []
    }
}
