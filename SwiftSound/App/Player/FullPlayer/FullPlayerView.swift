//
//  PlayerView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/24.
//

import SwiftUI

struct FullPlayerView: View {
    let model: PlayerPresentationModel
    let actions: PlayerControlsActions
    let onCollapse: () -> Void
    let onTogglePlaylist: (() -> Void)?

    @EnvironmentObject private var lyricsStore: LyricsStore
    @State private var themeColor: Color?

    private var theme: FullPlayerTheme {
        FullPlayerTheme(themeColor: themeColor)
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            PlayerModeBar()

            songContent

            PlayerBarView(
                model: model,
                actions: actions,
                style: theme.playerBarStyle,
                onActivate: onCollapse,
                onTogglePlaylist: onTogglePlaylist
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.background)
        .ignoresSafeArea(edges: .top)   // important
        .task(id: model.song.id) {
            lyricsStore.loadLyricsIfNeeded(for: model.song.id)
            await updateThemeColor()
        }
    }

    private var header: some View {
        HStack {
            Button(action: onCollapse) {
                Image(systemName: "chevron.down")
                    .font(.font18)
                    .foregroundStyle(.white)
                    .frame(width: Layout.collapseButtonSize, height: Layout.collapseButtonSize)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.leading, Layout.collapseButtonLeadingInset)
    }

    private var songContent: some View {
        HStack(alignment: .center, spacing: Layout.songContentColumnSpacing) {
            TurntableRecordView(song: model.song, playbackState: model.playbackState)
                .offset(y: Layout.recordOffsetY)

            SongDetailsView(
                song: model.song,
                currentTime: model.currentTime,
                onSeek: actions.onSeekAndPlay
            )
                .frame(width: Layout.songInfoWidth)
                .frame(maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension FullPlayerView {
    func updateThemeColor() async {
        themeColor = nil

        let color = await Color.themeColor(from: URL(string: model.song.album.picUrl))
        guard !Task.isCancelled else { return }

        withAnimation(.easeInOut(duration: 0.24)) {
            themeColor = color
        }
    }
}

private extension FullPlayerView {
    enum Layout {
        static let collapseButtonSize: CGFloat = 34
        static let collapseButtonLeadingInset: CGFloat = 76

        static let songContentColumnSpacing: CGFloat = 100
        static let songInfoWidth: CGFloat = 430
        static let recordOffsetY: CGFloat = -20
    }
}

#Preview {
    FullPlayerView(
        model: .preview(),
        actions: .preview,
        onCollapse: {},
        onTogglePlaylist: {}
    )
    .environmentObject(LyricsStore.preview())
    .frame(width: 1280, height: 800)
}
