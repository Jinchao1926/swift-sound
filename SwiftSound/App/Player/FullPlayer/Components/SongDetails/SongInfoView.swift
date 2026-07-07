//
//  SongInfoView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import SwiftUI

struct SongInfoView: View {
    let song: Song

    var body: some View {
        HStack(spacing: 20) {
            SongInfoItem(title: "专辑", value: song.album.name)
            SongInfoItem(title: "歌手", value: song.artistName ?? "未知歌手")
            SongInfoItem(title: "来源", value: song.artistName ?? "未知来源")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct SongInfoItem: View {
    let title: String
    let value: String

    var body: some View {
        Text("\(title): \(value)")
            .font(.font14)
            .foregroundStyle(Color.textSecondaryOnDark)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

#Preview {
    VStack {
        SongInfoView(song: .preview)
    }
    .frame(width: 400, height: 100)
    .background(Color(hex: 0xACA614))
}
