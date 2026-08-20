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
            ZStack(alignment: .top) {
                recordBacking
                albumCover
                    .padding(.top, Layout.recordHeight)
            }
            albumDetails
        }
        .background(hoverBackground)
        .rounded(radius: Layout.cornerRadius)
        .onHover { isHovering = $0 }
    }
}

private extension AlbumCard {
    var hoverBackground: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: Layout.recordHeight)

            isHovering ? Color.white : Color.clear
        }
    }

    var albumCover: some View {
        RemoteImage(url: URL(string: album.picUrl))
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .playbackOverlay(
                configuration: .init(
                    placement: .bottomTrailing(inset: Layout.playbackButtonInset),
                    buttonSize: Layout.playbackButtonSize,
                    iconFont: .font24
                ),
                isExternalHovering: isHovering,
                onPlaybackTap: onPlay
            )
            .rounded(radius: Layout.cornerRadius)
    }

    var recordBacking: some View {
        Image("song-cover-large")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .clipShape(Circle())
            .allowsHitTesting(false)
    }

    var albumDetails: some View {
        VStack(alignment: .leading, spacing: Layout.detailsSpacing) {
            Text(album.name)
                .font(.font16)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)

            if !albumDetailsText.isEmpty {
                Text(albumDetailsText)
                    .font(.font13)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, Layout.detailsHorizontalInset)
        .padding(.vertical, Layout.detailsVerticalInset)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var albumDetailsText: String {
        [album.size?.formattedSongCount(), album.publishTime?.formattedMillisecondsYearMonthDay()]
            .compactMap { $0 }
            .joined(separator: " · ")
    }
}

private extension AlbumCard {
    enum Layout {
        static let cornerRadius: CGFloat = 8
        static let recordHeight: CGFloat = 10

        static let detailsSpacing: CGFloat = 4
        static let detailsHorizontalInset: CGFloat = 13
        static let detailsVerticalInset: CGFloat = 10

        static let playbackButtonSize: CGFloat = 32
        static let playbackButtonInset: CGFloat = 15
    }
}

#Preview {
    VStack {
        AlbumCard(album: .preview) {}
    }
    .frame(width: 176)
    .padding()
    .background(Color.surfacePrimary)
}
