//
//  SongLyricsView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import SwiftUI
import Foundation

struct SongLyricsView: View {
    let song: Song
    let currentTime: TimeInterval
    let onSeek: (TimeInterval) -> Void

    @EnvironmentObject private var lyricsStore: LyricsStore

    var body: some View {
        switch lyricsStore.lyricState(for: song.id) {
        case .failed:
            LyricsFailedView {
                lyricsStore.loadLyricsIfNeeded(for: song.id)
            }

        case .loaded(let lines):
            if !lines.isEmpty {
                LyricsScrollView(
                    lines: lines,
                    currentTime: currentTime,
                    onSeek: onSeek
                )
            }

        case .idle, .loading(_):
            EmptyView()
        }
    }
}

#Preview {
    SongLyricsView(song: .preview, currentTime: 68, onSeek: { _ in })
        .environmentObject(LyricsStore.preview())
        .padding()
        .background(Color(hex: 0x151515))
}
