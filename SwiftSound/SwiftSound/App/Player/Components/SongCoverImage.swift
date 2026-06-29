//
//  SongCoverImage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

struct SongCoverImage: View {
    enum Variant {
        case small
        case large
    }

    let song: Song
    let variant: Variant

    init(song: Song, variant: Variant = .small) {
        self.song = song
        self.variant = variant
    }

    var body: some View {
        ZStack {
            Image(metrics.backgroundImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.01)

            RemoteImage(url: URL(string: song.album.picUrl))
                .clipShape(Circle())
                .padding(metrics.albumInset)
        }
        .frame(width: metrics.containerSize, height: metrics.containerSize)
        .clipShape(Circle())
    }

    private var metrics: Metrics {
        switch variant {
        case .small:
            Metrics(
                backgroundImageName: "song-cover",
                albumInset: 9,
                containerSize: 60
            )
        case .large:
            Metrics(
                backgroundImageName: "song-cover-large",
                albumInset: 46,
                containerSize: 310
            )
        }
    }

    private struct Metrics {
        let backgroundImageName: String
        let albumInset: CGFloat
        let containerSize: CGFloat
    }
}

#Preview {
    VStack(spacing: 24) {
        SongCoverImage(song: .preview)
        SongCoverImage(song: .preview, variant: .large)
    }
    .padding(80)
    .background(Color.black)
}
