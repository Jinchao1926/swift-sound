//
//  SongAudioFile.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/21.
//

import Foundation

struct SongAudioFile: Codable {
    let bitrate: Int
    let fileId: Int
    let size: Int?
    let volumeDelta: Double?
    let sampleRate: Int?

    init(bitrate: Int, fileId: Int, size: Int?, volumeDelta: Double?, sampleRate: Int?) {
        self.bitrate = bitrate
        self.fileId = fileId
        self.size = size
        self.volumeDelta = volumeDelta
        self.sampleRate = sampleRate
    }

    private enum CodingKeys: String, CodingKey {
        case bitrate = "br"
        case fileId = "fid"
        case size
        case volumeDelta = "vd"
        case sampleRate = "sr"
    }

    private enum TopSongsCodingKeys: String, CodingKey {
        case bitrate
        case fileId = "dfsId"
        case id
        case size
        case volumeDelta
        case sampleRate = "sr"
    }

    init(from decoder: any Decoder) throws {
        let legacyContainer = try decoder.container(keyedBy: CodingKeys.self)
        if let legacyAudioFile = try Self.decodeLegacy(from: legacyContainer) {
            self = legacyAudioFile
            return
        }

        let topSongsContainer = try decoder.container(keyedBy: TopSongsCodingKeys.self)
        self = try Self.decodeTopSongs(from: topSongsContainer)
    }

    private static func decodeLegacy(
        from container: KeyedDecodingContainer<CodingKeys>
    ) throws -> SongAudioFile? {
        guard let bitrate = try container.decodeIfPresent(Int.self, forKey: .bitrate) else {
            return nil
        }

        return SongAudioFile(
            bitrate: bitrate,
            fileId: try container.decode(Int.self, forKey: .fileId),
            size: try container.decodeIfPresent(Int.self, forKey: .size),
            volumeDelta: try container.decodeIfPresent(Double.self, forKey: .volumeDelta),
            sampleRate: try container.decodeIfPresent(Int.self, forKey: .sampleRate)
        )
    }

    private static func decodeTopSongs(
        from container: KeyedDecodingContainer<TopSongsCodingKeys>
    ) throws -> SongAudioFile {
        SongAudioFile(
            bitrate: try container.decode(Int.self, forKey: .bitrate),
            fileId: try container.decodeIfPresent(Int.self, forKey: .fileId)
                ?? container.decodeIfPresent(Int.self, forKey: .id)
                ?? 0,
            size: try container.decodeIfPresent(Int.self, forKey: .size),
            volumeDelta: try container.decodeIfPresent(Double.self, forKey: .volumeDelta),
            sampleRate: try container.decodeIfPresent(Int.self, forKey: .sampleRate)
        )
    }
}
