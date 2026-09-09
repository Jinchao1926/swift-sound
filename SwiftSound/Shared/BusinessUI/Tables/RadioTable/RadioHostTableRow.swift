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

    var followedCount: String { "\(host.userFollowedCount.formattedCount())人" }
}
