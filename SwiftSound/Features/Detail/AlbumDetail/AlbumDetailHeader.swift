//
//  AlbumDetailHeader.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/6.
//

import SwiftUI

struct AlbumDetailHeader: View {
    let album: Album?
    let subCount: Int?
    let onPlayAll: () -> Void

    var body: some View {
        HStack(spacing: Layout.horizontalSpacing) {
            VStack(spacing: 0) {
                recordPeek
                RemoteImage(url: album?.imageURL)
                    .frame(width: Layout.albumSize, height: Layout.albumSize)
                    .rounded(radius: Layout.albumRadius)
            }

            if let album {
                VStack(alignment: .leading, spacing: Layout.verticalSpacing) {
                    Text(album.name)
                        .font(.font18)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)

                    if album.hasMultipleArtists {
                        VStack(alignment: .leading, spacing: Layout.artistSpacing) {
                            artistView
                            publishTimeView
                        }
                    } else {
                        HStack(spacing: Layout.artistSpacing) {
                            artistView
                            publishTimeView
                        }
                    }

                    Spacer()

                    HStack(spacing: Layout.buttonSpacing) {
                        MusicActionButtons.playAll {
                            onPlayAll()
                        }
                        MusicActionButtons.favorite(subscribeTitle) {}
                        MusicActionButtons.download {}
                        MusicActionButtons.more {}
                    }
                }
                .padding(.top, Layout.recordVisibleHeight)
            }

            Spacer()
        }
        .frame(height: Layout.albumSize + Layout.recordVisibleHeight)
    }
}

private extension AlbumDetailHeader {
    var recordPeek: some View {
        recordImage
            .frame(width: Layout.albumSize, height: Layout.recordVisibleHeight, alignment: .top)
            .clipped()
    }

    var recordImage: some View {
        Image("song-cover-large")
            .resizable()
            .scaledToFit()
            .frame(width: Layout.albumSize, height: Layout.albumSize)
            .clipShape(Circle())
            .allowsHitTesting(false)
    }

    @ViewBuilder
    var artistView: some View {
        if let artists = album?.artists, artists.count > 1 {
            SeparatedText(
                items: artists.map {
                    SeparatedText.Item(title: $0.name, route: .artist(id: $0.id))
                }
            )
        } else if let artist = album?.artist {
            HStack(spacing: Layout.artistSpacing) {
                Avatar(url: artist.avatarURL, size: Layout.avatarSize)

                Text(artist.name)
                    .foregroundStyle(Color.textSecondary)
                    .font(.font13)
            }
            .routeLink(to: .artist(id: artist.id))
        }
    }

    @ViewBuilder
    var publishTimeView: some View {
        if let publishTime = album?.publishTime {
            Text("\(publishTime.formattedMillisecondsYearMonthDay()) 发布")
                .foregroundStyle(Color.textTertiary)
                .font(.font13)
        }
    }

    var subscribeTitle: String {
        guard let subCount else { return "收藏" }
        return subCount.formatted()
    }
}

private extension AlbumDetailHeader {
    enum Layout {
        static let horizontalSpacing: CGFloat = 25
        static let verticalSpacing: CGFloat = 16

        static let albumSize: CGFloat = 170
        static let albumRadius: CGFloat = 6
        static let recordVisibleHeight: CGFloat = 10

        static let artistSpacing: CGFloat = 10
        static let avatarSize: CGFloat = 25

        static let buttonSpacing: CGFloat = 12
    }
}

#Preview {
    VStack {
        AlbumDetailHeader(album: .preview, subCount: 7275, onPlayAll: {})
    }
    .padding()
}
