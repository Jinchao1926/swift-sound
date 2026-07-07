//
//  QueueTransition.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/23.
//

import Foundation

enum QueueTransition {
    case play(Song)
    case replay(Song)
    case stop
    case noChange
}
