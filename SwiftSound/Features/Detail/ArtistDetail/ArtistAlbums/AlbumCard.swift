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
    @State private var isPlayButtonHovering = false

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
        ZStack(alignment: .bottomTrailing) {
            RemoteImage(url: URL(string: album.picUrl))
                .scaledToFill()

            if isHovering {
                Color.black.opacity(0.28)

                playButton
                    .padding(Layout.playButtonMargin)
            }
        }
        .frame(width: Layout.width, height: Layout.width)
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
        .padding(.horizontal, Layout.textHorizontalMargin)
        .padding(.vertical, Layout.textVerticalMargin)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var playButton: some View {
        Button {
            onPlay()
        } label: {
            Image(systemName: "play.fill")
                .font(.font24)
                .foregroundStyle(Color.white)
                .frame(width: Layout.playButtonSize, height: Layout.playButtonSize)
                .scaleEffect(isPlayButtonHovering ? 1.12 : 1)
                .animation(.spring(response: 0.22, dampingFraction: 0.72), value: isPlayButtonHovering)
        }
        .buttonStyle(.plain)
        .onHover { isPlayButtonHovering = $0 }
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
        static let textHorizontalMargin: CGFloat = 13
        static let textVerticalMargin: CGFloat = 10

        static let playButtonSize: CGFloat = 32
        static let playButtonMargin: CGFloat = 15
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
