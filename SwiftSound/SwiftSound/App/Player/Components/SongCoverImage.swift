//
//  SongCoverImage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

struct SongCoverImage: View {
    let song: Song?

    var body: some View {
        ZStack {
            Image("song-cover")
                .resizable()
                .aspectRatio(contentMode: .fill)

            RemoteImage(url: songCoverURL)
                .clipShape(RoundedRectangle(cornerRadius: Layout.coverRadius, style: .continuous))
                .padding(Layout.inset)
        }
        .frame(width: Layout.coverSize, height: Layout.coverSize)
        .clipShape(RoundedRectangle(cornerRadius: Layout.coverRadius, style: .continuous))
    }
}

private extension SongCoverImage {
    enum Layout {
        static let inset: CGFloat = 10
        static let coverSize: CGFloat = 60
        static let coverRadius: CGFloat = (coverSize - 2 * inset) / 2
    }

    var songCoverURL: URL? {
        guard let picUrl = song?.album.picUrl else { return nil }
        return URL(string: picUrl)
    }
}

#Preview {
    SongCoverImage(song: nil)
        .padding(10)
}
