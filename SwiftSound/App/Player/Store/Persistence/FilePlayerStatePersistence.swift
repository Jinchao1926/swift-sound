//
//  FilePlayerStatePersistence.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/25.
//

import Foundation

final class FilePlayerStatePersistence: PlayerStatePersistence {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let fileManager: FileManager

    init(
        fileManager: FileManager = .default,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder
        self.fileURL = Self.defaultFileURL(fileManager: fileManager)
    }

    func load() -> PlayerState? {
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }

        do {
            let data = try Data(contentsOf: fileURL)
            let snapshot = try decoder.decode(PlayerStateSnapshot.self, from: data)
            return snapshot.makePlayerState()
        } catch {
            return nil
        }
    }

    func save(_ state: PlayerState) {
        do {
            try fileManager.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try encoder.encode(PlayerStateSnapshot(state: state))
            try data.write(to: fileURL, options: .atomic)
        } catch {
            return
        }
    }

    func clear() {
        guard fileManager.fileExists(atPath: fileURL.path) else { return }
        try? fileManager.removeItem(at: fileURL)
    }

    private static func defaultFileURL(fileManager: FileManager) -> URL {
        let baseURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.temporaryDirectory
        return baseURL
            .appendingPathComponent("SwiftSound", isDirectory: true)
            .appendingPathComponent("player-state.json")
    }
}
