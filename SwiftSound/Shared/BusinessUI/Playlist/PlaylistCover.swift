//
//  PlaylistCover.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/15.
//

import SwiftUI

struct PlaylistCover: View {
    let playlist: Playlist

    @State private var isHovering = false
    @StateObject private var themeColorLoader = ThemeColorLoader()

    var body: some View {
        VStack(spacing: 0) {
            RemoteImage(url: playlist.coverURL)
                .aspectRatio(1, contentMode: .fit)

            Color.clear
                .frame(height: Layout.bottomPanelHeight)
        }
        .overlay(alignment: .topTrailing) {
            PlayCountBadge(count: playlist.playCount)
                .padding(Layout.inset)
        }
        .overlay(alignment: .bottom) {
            PlaylistCoverBottomPanel(
                title: playlist.name,
                tracks: tracks,
                themeColor: themeColorLoader.color,
                isHovering: isHovering
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: isHovering ? .infinity : Layout.bottomPanelHeight,
                alignment: .bottom
            )
        }
        .rounded()
        .pointerStyle(.link)
        .onHover { isHovering = $0 }
        .task(id: playlist.coverURL) {
            await themeColorLoader.load(from: playlist.coverURL)
        }
        .animation(.easeInOut(duration: 0.18), value: isHovering)
    }
}

fileprivate extension PlaylistCover {
    enum Layout {
        static let inset: CGFloat = 10
        static let bottomPanelHeight: CGFloat = 58
    }

    var tracks: [Song] { Array((playlist.tracks ?? []).prefix(3)) }
}

// MARK: - PlaylistCoverBottomPanel
private struct PlaylistCoverBottomPanel: View {
    let title: String
    let tracks: [Song]
    let themeColor: Color?
    let isHovering: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            background

            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 0)

                titleView
                    .padding(.horizontal, Layout.inset)
                    .padding(.top, Layout.inset)
                    .padding(.bottom, Layout.bottomInset)

                tracksView
                    .padding(.horizontal, Layout.inset)
                    .padding(.bottom, Layout.bottomInset)
                    .opacity(isHovering ? 1 : 0)
                    .offset(y: isHovering ? 0 : 8)
                    .frame(height: isHovering ? nil : 0, alignment: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
    }
}

private extension PlaylistCoverBottomPanel {
    enum Layout {
        static let inset: CGFloat = 10
        static let bottomInset: CGFloat = 15
    }

    var titleView: some View {
        Text(title)
            .font(.font13)
            .foregroundStyle(.white)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .lineSpacing(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var tracksView: some View {
        HStack(alignment: .bottom, spacing: Layout.inset) {
            PlaylistCoverTrackList(tracks: tracks)
            Spacer(minLength: Layout.inset)
            PlayButton()
        }
    }

    var background: some View {
        LinearGradient(
            stops: [
                .init(color: panelColor, location: 0),
                .init(color: panelColor, location: 0.5),
                .init(color: panelColor.opacity(isHovering ? 0.52 : 1), location: 0.78),
                .init(color: panelColor.opacity(isHovering ? 0 : 1), location: 1)
            ],
            startPoint: .bottom,
            endPoint: .top
        )
    }

    var panelColor: Color {
        themeColor ?? Color(hex: 0xA55E76)
    }
}

// MARK: - PlaylistCoverTrackList
private struct PlaylistCoverTrackList: View {
    let tracks: [Song]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(tracks.enumerated()), id: \.element.id) { index, track in
                Text("\(index + 1) \(track.name)")
                    .font(.font12.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}
