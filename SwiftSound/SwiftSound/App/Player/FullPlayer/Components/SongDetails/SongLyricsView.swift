//
//  SongLyricsView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import SwiftUI

struct SongLyricsView: View {
    let song: Song

    @EnvironmentObject private var lyricsStore: LyricsStore

    var body: some View {
        switch lyricsStore.lyricState(for: song.id) {
        case .failed:
            failedState

        case .loaded(let lines):
            if !lines.isEmpty {
                lyricsList(lines)
            }

        case .idle, .loading:
            EmptyView()
        }
    }

    private func lyricsList(_ lines: [LyricLine]) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                    Text(line.text.isEmpty ? " " : line.text)
                        .font(.font20)
                        .foregroundStyle(Color.textTertiaryOnDark)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var failedState: some View {
        VStack(spacing: 28) {
            Text("歌词加载失败")
                .font(.font32)
                .foregroundStyle(Color.textSecondaryOnDark)
                .lineLimit(1)

            Button {
                lyricsStore.loadLyricsIfNeeded(for: song.id)
            } label: {
                Text("刷新")
                    .font(.font20)
                    .foregroundStyle(Color.textPrimaryOnDark)
                    .frame(width: 96, height: 42)
                    .overlay {
                        Capsule()
                            .stroke(Color.textSecondaryOnDark, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, minHeight: 360, alignment: .center)
    }
}

#Preview {
    SongLyricsView(song: .preview)
        .environmentObject(LyricsStore.preview())
        .padding()
        .background(Color(hex: 0x151515))
}
