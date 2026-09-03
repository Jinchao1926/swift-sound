//
//  PlaybackQueue.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import Foundation

struct PlaybackQueue {
    private(set) var songs: [Song] = []
    private(set) var currentIndex: Int?

    var currentSong: Song? { songs[safe: currentIndex] }
    var isEmpty: Bool { songs.isEmpty }

    // MARK: - LifeCycle
    init(songs: [Song] = [], currentIndex: Int? = nil) {
        self.songs = songs
        if let currentIndex, songs.indices.contains(currentIndex) {
            self.currentIndex = currentIndex
        } else {
            self.currentIndex = nil
        }
    }

    // MARK: - Public
    mutating func play(_ song: Song) -> QueueTransition {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            let isReplayingCurrentSong = currentSong?.id == song.id
            currentIndex = index
            return isReplayingCurrentSong ? .replay(song) : .play(song)
        } else {
            songs.append(song)
            currentIndex = songs.count - 1
            return .play(song)
        }
    }

    mutating func play(at index: Int) -> QueueTransition {
        guard let song = songs[safe: index] else { return .noChange }

        let isReplayingCurrentSong = currentSong?.id == song.id
        currentIndex = index
        return isReplayingCurrentSong ? .replay(song) : .play(song)
    }

    mutating func append(_ song: Song) -> Bool {
        guard !songs.contains(where: { $0.id == song.id }) else { return false }
        songs.append(song)

        return true
    }

    mutating func appendMany(_ array: [Song]) -> Bool {
        // 过滤掉已存在的歌曲
        let queueIds = songs.map(\.id)
        let newSongs = array.filter {
            !queueIds.contains($0.id)
        }

        guard !newSongs.isEmpty else { return false }
        songs.append(contentsOf: newSongs)

        return true
    }

    mutating func replace(with songs: [Song], startIndex: Int) -> QueueTransition {
        let previousCurrentSongID = currentSong?.id
        self.songs = songs

        guard let song = songs[safe: startIndex] else {
            currentIndex = nil
            return .stop
        }

        currentIndex = startIndex
        return previousCurrentSongID == song.id ? .replay(song) : .play(song)
    }

    mutating func remove(songId: Song.ID, mode: PlaybackMode) -> QueueTransition {
        guard let removedIndex = songs.firstIndex(where: { $0.id == songId }) else { return .noChange }

        let wasCurrentSong = removedIndex == currentIndex
        let oldCurrentIndex = currentIndex
        songs.remove(at: removedIndex)

        // 删除完队列为空时
        guard !songs.isEmpty else {
            currentIndex = nil
            return .stop
        }

        guard wasCurrentSong else {
            // 删除歌曲索引在当前歌曲之前，需要修正 `currentIndex`
            if let oldCurrentIndex, removedIndex < oldCurrentIndex {
                currentIndex = oldCurrentIndex - 1
            }
            return .noChange
        }

        // 删除当前歌曲时，自动播放下一首
        switch mode {
        case .listLoop, .singleLoop:
            currentIndex = removedIndex % songs.count
            return currentSong.map(QueueTransition.play) ?? .stop

        case .shuffle:
            currentIndex = Int.random(in: songs.indices)
            return currentSong.map(QueueTransition.play) ?? .stop

        case .sequential:
            guard removedIndex < songs.count else {
                currentIndex = nil
                return .stop
            }

            currentIndex = removedIndex
            return currentSong.map(QueueTransition.play) ?? .stop
        }
    }

    mutating func clear() {
        songs = []
        currentIndex = nil
    }

    mutating func moveNext(mode: PlaybackMode) -> QueueTransition {
        move(.next, mode: mode)
    }

    mutating func movePrevious(mode: PlaybackMode) -> QueueTransition {
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

    mutating func move(_ direction: Direction, mode: PlaybackMode) -> QueueTransition {
        guard !songs.isEmpty else {
            // 切歌时队列空
            currentIndex = nil
            return .stop
        }

        currentIndex = validCurrentIndex()
        guard let currentIndex else {
            // 队列非空，但是当前歌曲为空，统一播放第一首歌
            currentIndex = 0
            return currentSong.map(QueueTransition.play) ?? .stop
        }

        switch mode {
        case .listLoop:
            self.currentIndex = loopedIndex(from: currentIndex, direction: direction)
            return currentSong.map(QueueTransition.play) ?? .stop

        case .singleLoop:
            self.currentIndex = currentIndex
            return currentSong.map(QueueTransition.replay) ?? .stop

        case .shuffle:
            self.currentIndex = shuffledIndex(excluding: currentIndex)
            return currentSong.map(QueueTransition.play) ?? .stop

        case .sequential:
            let nextIndex = currentIndex + direction.offset
            guard songs.indices.contains(nextIndex) else {
                // 超出范围表示播完
                return .stop
            }

            self.currentIndex = nextIndex
            return currentSong.map(QueueTransition.play) ?? .stop
        }
    }

    func validCurrentIndex() -> Int? {
        guard let currentIndex else { return nil }
        guard songs.indices.contains(currentIndex) else { return nil }
        return currentIndex
    }

    func loopedIndex(from currentIndex: Int, direction: Direction) -> Int {
        return (currentIndex + direction.offset + songs.count) % songs.count
    }

    func shuffledIndex(excluding currentIndex: Int?) -> Int {
        guard songs.count > 1 else { return 0 }

        var index = Int.random(in: songs.indices)
        if index == currentIndex {
            index = (index + 1) % songs.count
        }
        return index
    }
}
