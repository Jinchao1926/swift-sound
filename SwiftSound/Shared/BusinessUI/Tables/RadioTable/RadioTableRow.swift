//
//  RadioTableRow.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/10.
//

import Foundation
import SwiftUI

struct RadioTableRow: MusicTableRow {
    let radio: any RadioProviding
    let playbackStatus: MusicTablePlaybackStatus

    init(
        radio: any RadioProviding,
        playbackStatus: MusicTablePlaybackStatus = .notCurrent
    ) {
        self.radio = radio
        self.playbackStatus = playbackStatus
    }

    var id: Int { radio.id }
    var imageURL: URL? { radio.imageURL }
    var title: String { radio.name }
    var subtitle: String? { radio.rcmdtext }

    var creatorID: Int? { radio.creatorID }
    var creatorName: String { radio.creatorName }

    var programCount: String? { radio.programCount?.formattedCount() }
    var playCount: String? { radio.playCount?.formattedCount() }
}
