//
//  FullPlayerSongDetailsView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/29.
//

import SwiftUI

struct SongDetailsView: View {
    let song: Song

    @State private var selectedTab: SongDetailsTab = .lyrics

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            title

            SongMetadataView(song: song)
                .padding(.top, 8)

            SongDetailsTabBar(selectedTab: $selectedTab)
                .padding(.vertical, 25)

            tabContent

            Spacer(minLength: 0)
        }
        .padding(.top, 40)
    }

    private var title: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(song.name)
                .font(.font24)
                .foregroundStyle(Color.textPrimaryOnDark)
                .lineLimit(1)

            if song.hasMV {
                SongBadge(
                    "MV>",
                    tint: Color.textSecondaryOnDark,
                    size: .small,
                    isInteractive: true
                )
            }
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .lyrics:
            SongLyricsView(song: song)
        case .wiki:
            SongWikiView(song: song)
        case .similar:
            SimilarSongsView(song: song)
        }
    }
}

#Preview {
    VStack {
        SongDetailsView(song: .preview)
            .frame(width: 430, height: 650)
    }
    .background(Color(hex: 0xACA614))
}
