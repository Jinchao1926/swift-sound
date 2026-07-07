//
//  PlayerStatePersistence.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/25.
//

import Foundation

protocol PlayerStatePersistence {
    func load() -> PlayerState?
    func save(_ state: PlayerState)
    func clear()
}
