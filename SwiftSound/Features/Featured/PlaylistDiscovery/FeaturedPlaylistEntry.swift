//
//  FeaturedPlaylistEntry.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/18.
//

import SwiftUI

struct FeaturedPlaylistEntry: View {
    let playlist: Playlist?
    @State private var themeColor: Color?

    private var playlistColor: Color { themeColor ?? Color(hex: 0xA55E76) }

    var body: some View {
        VStack(spacing: 0) {
            playlistColor
                .frame(width: Layout.size, height: Layout.size)
                .overlay {
                    VStack(spacing: Layout.imageOverlaySpacing) {
                        Text("精品歌单")
                            .font(.font16)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)

                        playlistCovers
                    }
                }
                .overlay(alignment: .topLeading) {
                    ZStack(alignment: .topLeading) {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: Layout.badgeSize, height: Layout.badgeSize)
                            .offset(x: -Layout.badgeSize / 2, y: -Layout.badgeSize / 2)

                        Image(systemName: "crown.fill")
                            .font(.font8)
                            .foregroundStyle(Color.white.opacity(0.6))
                            .padding(Layout.badgePadding)
                    }
                    .frame(width: Layout.badgeSize, height: Layout.badgeSize)
                    .clipped()
                }
                .rounded()

            Text(playlist?.name ?? "")
                .font(.font13)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)
                .padding(.vertical, Layout.textVerticalSpacing)
                .padding(.horizontal, Layout.textHorizontalSpacing)
        }
        .frame(width: Layout.size)
        .task(id: playlist?.coverURL) {
            await updateThemeColor(from: playlist?.coverURL)
        }
    }
}

private extension FeaturedPlaylistEntry {
    var playlistCovers: some View {
        ZStack {
            RemoteImage(url: playlist?.coverURL)
                .frame(width: Layout.backgroundImageWidth, height: Layout.backgroundImageHeight)
                .rounded()
                .opacity(0.6)

            RemoteImage(url: playlist?.coverURL)
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .rounded()
        }
    }
}

private extension FeaturedPlaylistEntry {
    func updateThemeColor(from imageURL: URL?) async {
        themeColor = nil

        let color = await Color.themeColor(from: imageURL)
        guard !Task.isCancelled else { return }

        themeColor = color
    }
}

private extension FeaturedPlaylistEntry {
    enum Layout {
        static let size: CGFloat = 116

        static let imageOverlaySpacing: CGFloat = 14
        static let imageSize: CGFloat = 58
        static let backgroundImageWidth: CGFloat = imageSize + 18
        static let backgroundImageHeight: CGFloat = imageSize - 18

        static let badgeSize: CGFloat = 45
        static let badgePadding: CGFloat = 3
        static let textVerticalSpacing: CGFloat = 6
        static let textHorizontalSpacing: CGFloat = 4
    }
}

#Preview {
    FeaturedPlaylistEntry(playlist: .featuredPreview)
}
