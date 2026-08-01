//
//  AlbumCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/31.
//

import SwiftUI

struct AlbumCard: View {
    let album: Album

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.coverBottomSpacing) {
            cover

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
        }
        .frame(width: Layout.width)
//        .frame(minWidth: Layout.width, maxWidth: .infinity, alignment: .leading)
    }

    private var cover: some View {
        Image("song-cover-large")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .overlay(alignment: .top) {
                RemoteImage(url: URL(string: album.picUrl))
                    .aspectRatio(1, contentMode: .fill)
                    .rounded(radius: Layout.coverRadius)
                    .offset(y: Layout.recordVisibleHeight)
            }
            .padding(.bottom, Layout.recordVisibleHeight)
    }

    private var metadataText: String {
        [album.size?.songCountText, album.publishTime?.millisecondsYearMonthDayText]
            .compactMap { $0 }
            .joined(separator: " · ")
    }
}

private extension AlbumCard {
    enum Layout {
        static let width: CGFloat = 178
        static let coverRadius: CGFloat = 8
        static let coverBottomSpacing: CGFloat = 10
        static let recordVisibleHeight: CGFloat = 10

        static let textSpacing: CGFloat = 4
        static let textHorizontalMargin: CGFloat = 13
    }
}

#Preview {
    VStack {
        AlbumCard(album: .preview)
    }
    .frame(width: 220)
    .padding()
    .background(Color.surfacePrimary)
}
