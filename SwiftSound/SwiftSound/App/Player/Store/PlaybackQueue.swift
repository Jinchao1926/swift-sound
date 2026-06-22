//
//  PlaybackQueue.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

enum QueueMoveResult {
    case moved
    case stopped
    case unchanged
}

struct PlaybackQueue {
    private(set) var queue: [Song] = []
    private(set) var currentIndex: Int?

    var currentSong: Song? { queue[safe: currentIndex] }
    var isEmpty: Bool { queue.isEmpty }

    mutating func play(_ song: Song) {
        if let index = queue.firstIndex(where: { $0.id == song.id }) {
            currentIndex = index
        } else {
            queue.append(song)
            currentIndex = queue.count - 1
        }
    }

    mutating func play(at index: Int) -> QueueMoveResult {
        guard queue.indices.contains(index) else { return .unchanged }

        currentIndex = index
        return .moved
    }

    mutating func append(_ song: Song) {
        guard !queue.contains(where: { $0.id == song.id }) else { return }
        queue.append(song)
    }

    mutating func appendMany(_ songs: [Song]) {
        // 过滤掉已存在的歌曲
        let queueIds = queue.map(\.id)
        let newSongs = songs.filter {
            !queueIds.contains($0.id)
        }

        guard !newSongs.isEmpty else { return }
        queue.append(contentsOf: newSongs)
    }

    mutating func remove(songId: Song.ID, mode: PlaybackMode) -> QueueMoveResult {
        guard let removedIndex = queue.firstIndex(where: { $0.id == songId }) else { return .unchanged }

        let wasCurrentSong = removedIndex == currentIndex
        let oldCurrentIndex = currentIndex
        queue.remove(at: removedIndex)

        // 删除完队列为空时
        guard !queue.isEmpty else {
            currentIndex = nil
            return .stopped
        }

        guard wasCurrentSong else {
            // 删除歌曲索引在当前歌曲之前，需要修正 `currentIndex`
            if let oldCurrentIndex, removedIndex < oldCurrentIndex {
                currentIndex = oldCurrentIndex - 1
            }
            return .unchanged
        }

        // 删除当前歌曲时，自动播放下一首
        switch mode {
        case .listLoop, .singleLoop:
            currentIndex = removedIndex % queue.count
            return .moved

        case .shuffle:
            currentIndex = Int.random(in: queue.indices)
            return .moved

        case .sequential:
            guard removedIndex < queue.count else {
                currentIndex = nil
                return .stopped
            }

            currentIndex = removedIndex
            return .moved
        }
    }

    mutating func clear() {
        queue = []
        currentIndex = nil
    }

    mutating func moveNext(mode: PlaybackMode) -> QueueMoveResult {
        move(.next, mode: mode)
    }

    mutating func movePrevious(mode: PlaybackMode) -> QueueMoveResult {
        move(.previous, mode: mode)
    }
}

private extension PlaybackQueue {
    enum Direction {
        case next
        case previous

        var offset: Int {
            switch self {
            case .next:
                return 1
            case .previous:
                return -1
            }
        }
    }

    mutating func move(_ direction: Direction, mode: PlaybackMode) -> QueueMoveResult {
        guard !queue.isEmpty else {
            currentIndex = nil
            return .stopped
        }

        currentIndex = validCurrentIndex()

        switch mode {
        case .listLoop:
            let fallbackIndex = direction == .next ? queue.count - 1 : 0
            currentIndex = loopedIndex(from: currentIndex ?? fallbackIndex, direction: direction)
            return .moved

        case .singleLoop:
            currentIndex = currentIndex ?? 0
            return .moved

        case .shuffle:
            currentIndex = shuffledIndex(excluding: currentIndex)
            return .moved

        case .sequential:
            guard let currentIndex else {
                self.currentIndex = direction == .next ? 0 : queue.count - 1
                return .moved
            }

            let nextIndex = currentIndex + direction.offset
            guard queue.indices.contains(nextIndex) else {
                // 超出范围表示播完
                return .stopped
            }

            self.currentIndex = nextIndex
            return .moved
        }
    }

    func validCurrentIndex() -> Int? {
        guard let currentIndex else { return nil }
        guard queue.indices.contains(currentIndex) else { return nil }
        return currentIndex
    }

    func loopedIndex(from currentIndex: Int, direction: Direction) -> Int {
        (currentIndex + direction.offset + queue.count) % queue.count
    }

    func shuffledIndex(excluding currentIndex: Int?) -> Int {
        guard queue.count > 1 else { return 0 }

        var index = Int.random(in: queue.indices)
        if index == currentIndex {
            index = (index + 1) % queue.count
        }
        return index
    }
}
