//
//  SongCoverImage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

struct SongCoverImage: View {
    let song: Song

    var body: some View {
        ZStack {
            Image("song-cover")
                .resizable()
                .aspectRatio(contentMode: .fill)

            RemoteImage(url: URL(string: song.album.picUrl))
                .clipShape(RoundedRectangle(cornerRadius: Layout.coverRadius, style: .continuous))
                .padding(Layout.inset)
        }
        .frame(width: Layout.coverSize, height: Layout.coverSize)
        .clipShape(RoundedRectangle(cornerRadius: Layout.coverRadius, style: .continuous))
    }
}

private extension SongCoverImage {
    enum Layout {
        static let inset: CGFloat = 9
        static let coverSize: CGFloat = 60
        static let coverRadius: CGFloat = (coverSize - 2 * inset) / 2
    }
}

#Preview {
    SongCoverImage(song: .preview)
        .padding(10)
}
