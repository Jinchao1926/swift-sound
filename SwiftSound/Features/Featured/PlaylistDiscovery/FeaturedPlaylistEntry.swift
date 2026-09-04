//
//  FeaturedPlaylistEntry.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/18.
//

import SwiftUI

struct FeaturedPlaylistEntry: View {
    let playlist: Playlist?
    @StateObject private var themeColorLoader = ThemeColorLoader()

    private var playlistColor: Color { themeColorLoader.color ?? Color(hex: 0xA55E76) }

    var body: some View {
        VStack(spacing: 0) {
            playlistColor
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .overlay {
                    VStack(spacing: Layout.imageOverlayInset) {
                        Text("精品歌单")
                            .font(.font16)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)

                        playlistCovers
                    }
                }
                .overlay(alignment: .topLeading) {
                    crownView
                }
                .rounded()

            Text(playlist?.name ?? "")
                .font(.font13)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)
                .padding(.vertical, Layout.textVerticalInset)
                .padding(.horizontal, Layout.textHorizontalInset)
        }
        .task(id: playlist?.imageURL) {
            await themeColorLoader.load(from: playlist?.imageURL)
        }
    }
}

private extension FeaturedPlaylistEntry {
    var playlistCovers: some View {
        ZStack {
            RemoteImage(url: playlist?.imageURL)
                .frame(width: Layout.backgroundImageWidth, height: Layout.backgroundImageHeight)
                .rounded()
                .opacity(0.6)

            RemoteImage(url: playlist?.imageURL)
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .rounded()
        }
    }

    var crownView: some View {
        ZStack(alignment: .topLeading) {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: Layout.badgeSize, height: Layout.badgeSize)
                .offset(x: -Layout.badgeSize / 2, y: -Layout.badgeSize / 2)

            Image(systemName: "crown.fill")
                .font(.font8)
                .foregroundStyle(Color.white.opacity(0.6))
                .padding(Layout.badgeInset)
        }
        .frame(width: Layout.badgeSize, height: Layout.badgeSize)
    }
}

private extension FeaturedPlaylistEntry {
    enum Layout {
        static let imageOverlayInset: CGFloat = 14
        static let imageSize: CGFloat = 58
        static let backgroundImageWidth: CGFloat = imageSize + 18
        static let backgroundImageHeight: CGFloat = imageSize - 18

        static let badgeSize: CGFloat = 45
        static let badgeInset: CGFloat = 3
        static let textVerticalInset: CGFloat = 6
        static let textHorizontalInset: CGFloat = 4
    }
}

#Preview {
    FeaturedPlaylistEntry(playlist: .featuredPreview)
        .frame(width: 116)
}
