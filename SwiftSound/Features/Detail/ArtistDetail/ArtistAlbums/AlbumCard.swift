//
//  AlbumCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/31.
//

import SwiftUI

struct AlbumCard: View {
    let album: Album
    let onPlay: () -> Void

    @State private var isHovering = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0) {
                recordPeek
                coverAlbum
            }
            .frame(width: Layout.width)
            metadata
        }
        .frame(width: Layout.width)
        .background(cardBackground)
        .rounded(radius: Layout.radius)
        .onHover { isHovering = $0 }
    }

    private var cardBackground: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: Layout.recordVisibleHeight)

            isHovering ? Color.white : Color.clear
        }
    }

    private var coverAlbum: some View {
        RemoteImage(url: URL(string: album.picUrl))
            .frame(width: Layout.width, height: Layout.width)
            .playbackOverlay(
                configuration: .init(
                    placement: .bottomTrailing(inset: Layout.playButtonPadding),
                    buttonSize: Layout.playButtonSize,
                    iconFont: .font24
                ),
                isExternalHovering: isHovering,
                onPlaybackTap: onPlay
            )
            .rounded(radius: Layout.radius)
    }

    private var recordPeek: some View {
        recordImage
            .frame(width: Layout.width, height: Layout.recordVisibleHeight, alignment: .top)
            .clipped()
    }

    private var recordImage: some View {
        Image("song-cover-large")
            .resizable()
            .scaledToFit()
            .frame(width: Layout.width, height: Layout.width)
            .clipShape(Circle())
            .allowsHitTesting(false)
    }

    private var metadata: some View {
        VStack(alignment: .leading, spacing: Layout.textSpacing) {
            Text(album.name)
                .font(.font16)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)

            if !metadataText.isEmpty {
                Text(metadataText)
                    .font(.font13)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, Layout.textHorizontalPadding)
        .padding(.vertical, Layout.textVerticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var metadataText: String {
        [album.size?.formattedSongCount(), album.publishTime?.formattedMillisecondsYearMonthDay()]
            .compactMap { $0 }
            .joined(separator: " · ")
    }
}

private extension AlbumCard {
    enum Layout {
        static let width: CGFloat = 178
        static let radius: CGFloat = 8
        static let recordVisibleHeight: CGFloat = 10

        static let textSpacing: CGFloat = 4
        static let textHorizontalPadding: CGFloat = 13
        static let textVerticalPadding: CGFloat = 10

        static let playButtonSize: CGFloat = 32
        static let playButtonPadding: CGFloat = 15
    }
}

#Preview {
    VStack {
        AlbumCard(album: .preview) {}
    }
    .frame(width: 220)
    .padding()
    .background(Color.surfacePrimary)
}
