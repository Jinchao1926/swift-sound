//
//  SongLyricsView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import SwiftUI

struct SongLyricsView: View {
    let song: Song

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            ForEach(creditLines, id: \.self) { line in
                Text(line)
                    .font(.font14)
                    .foregroundStyle(Color.textTertiaryOnDark)
                    .lineLimit(1)
            }
        }
    }

    private var creditLines: [String] {
        [
            "作曲: 陈小霞",
            "编曲: 陈辉阳",
            "制作人: 陈小霞 / 陈辉阳",
            "录音师: 陈忠宏 / 亚祥 (HK)",
            "录音室: 白金 / AVON (HK)",
            "混音工程师: 王家栋",
            "混音录音室: 节奏"
        ]
    }
}

#Preview {
    SongLyricsView(song: .preview)
        .padding()
        .background(Color(hex: 0x151515))
}
