//
//  QueueAction.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

enum QueueAction {
    case append(Song)
    case appendMany([Song])
    case remove(songId: Int)
    case clear
}
