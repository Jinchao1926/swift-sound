//
//  FeaturedPlaylistCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/19.
//

import SwiftUI

struct FeaturedPlaylistCard: View {
    let playlist: Playlist
    let onPlay: () -> Void

    @State private var isHovering = false
    @StateObject private var themeColorLoader = ThemeColorLoader()

    var body: some View {
        VStack(spacing: 0) {
            RemoteImage(url: playlist.coverURL)
                .aspectRatio(1, contentMode: .fit)
                .playbackOverlay(
                    configuration: .init(
                        placement: .bottomTrailing(inset: Layout.playbackButtonInset),
                        style: .light,
                        iconFont: .font28
                    ),
                    isExternalHovering: isHovering,
                    onPlaybackTap: onPlay
                )

            VStack {
                Text(playlist.name)
                    .font(.font14)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .lineSpacing(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(Layout.titleInset)
            }
            .frame(height: Layout.bottomTitleHeight)
            .background(themeColorLoader.color)
        }
        .overlay(alignment: .topTrailing) {
            PlayCountBadge(count: playlist.playCount)
                .padding(Layout.badgeInset)
        }
        .rounded()
        .onHover { isHovering = $0 }
        .task(id: playlist.coverURL) {
            await themeColorLoader.load(from: playlist.coverURL)
        }
        .animation(.easeInOut(duration: 0.18), value: isHovering)
    }
}

fileprivate extension FeaturedPlaylistCard {
    enum Layout {
        static let bottomTitleHeight: CGFloat = 58
        static let titleInset: CGFloat = 8
        static let badgeInset: CGFloat = 10
        static let playbackButtonInset: CGFloat = 15
    }
}

#Preview {
    VStack {
        FeaturedPlaylistCard(playlist: .featuredPreview) {}
    }
    .frame(width: 180)
    .padding()
}
