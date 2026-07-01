//
//  PlayerView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/24.
//

import SwiftUI

struct FullPlayerView: View {
    let model: PlayerPresentationModel
    let callback: PlayerControlsCallback
    let onCollapse: () -> Void

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
                callback: callback,
                style: theme.playerBarStyle,
                onActivate: onCollapse
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.background)
        .ignoresSafeArea(edges: .top)   // important
        .task(id: model.song.id) {
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

            SongDetailsView(song: model.song)
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
        callback: .preview,
        onCollapse: {}
    )
    .frame(width: 1280, height: 800)
}
