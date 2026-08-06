//
//  AlbumDetailHeader.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/6.
//

import SwiftUI

struct AlbumDetailHeader: View {
    let album: Album

    var body: some View {
        HStack(spacing: Layout.spacing) {
            VStack(spacing: 0) {
                recordPeek
                RemoteImage(url: URL(string: album.picUrl))
                    .frame(width: Layout.albumSize, height: Layout.albumSize)
                    .rounded(radius: Layout.albumRadius)
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(album.name)
                    .font(.font18)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                HStack(spacing: Layout.artistSpacing) {
                    if let artist = album.artist {
                        HStack(spacing: Layout.artistSpacing) {
                            Avatar(url: artist.avatarURL, size: Layout.avatarSize)

                            Text(artist.name)
                                .foregroundStyle(Color.textSecondary)
                        }
                        .routeLink(to: .artist(id: artist.id))
                    }

                    if let publishTime = album.publishTime {
                        Text("\(publishTime.millisecondsYearMonthDayText) 发布")
                            .foregroundStyle(Color.textTertiary)
                    }
                }
                .font(.font13)
                .padding(.top, Layout.artistTopPadding)

                Spacer()

                HStack(spacing: Layout.buttonSpacing) {
                    ActionButton(
                        "播放全部",
                        systemName: "play.fill",
                        variant: .primary
                    ) {}
                    ActionButton("收藏", systemName: "plus.square.fill" ) {}
                    ActionButton("下载", systemName: "arrow.down.square.fill" ) {}
                    ActionButton(systemName: "ellipsis" ) {}
                }
            }
            .padding(.top, Layout.recordVisibleHeight)

            Spacer()
        }
        .frame(height: Layout.albumSize + Layout.recordVisibleHeight)
    }

    private var recordPeek: some View {
        recordImage
            .frame(width: Layout.albumSize, height: Layout.recordVisibleHeight, alignment: .top)
            .clipped()
    }

    private var recordImage: some View {
        Image("song-cover-large")
            .resizable()
            .scaledToFit()
            .frame(width: Layout.albumSize, height: Layout.albumSize)
            .clipShape(Circle())
            .allowsHitTesting(false)
    }
}

private extension AlbumDetailHeader {
    enum Layout {
        static let spacing: CGFloat = 25
        static let albumSize: CGFloat = 170
        static let albumRadius: CGFloat = 6
        static let recordVisibleHeight: CGFloat = 10

        static let artistTopPadding: CGFloat = 16
        static let artistSpacing: CGFloat = 10
        static let avatarSize: CGFloat = 25

        static let buttonSpacing: CGFloat = 12
    }
}

#Preview {
    VStack {
        AlbumDetailHeader(album: .preview)
    }
    .padding()
}
