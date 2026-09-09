//
//  RadioHostTableRow.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import Foundation
import SwiftUI

struct RadioHostTableRow: Identifiable {
    let host: RadioHost

    var id: Int { host.id }

    var imageURL: URL? { host.imageURL }

    var title: String { host.nickName }

    var avatarDetail: AvatarDetail? { host.avatarDetail }

    var followedCount: String {
        "\(host.userFollowedCount.formattedCount(threshold: .hundredThousand))人"
    }
}
