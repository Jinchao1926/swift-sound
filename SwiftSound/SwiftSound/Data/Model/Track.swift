//
//  Track.swift
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

struct Track: Decodable {
    let id: Int
    let name: String
    // 时长，毫秒
    let dt: Int
    // 歌手信息
    let ar: [Artist]
    // 专辑信息
    let al: Album
    // Track Name Supplement - 曲目名称补充
    let tns: [String]?
    let alia: [String]
    let mv: Int
    // 付费类型，参考 FeeType 枚举
    let fee: FeeType?
    // 用于表示各种曲目属性（VIP、独家、高品质等）的位标志
    let mark: Int?
}
