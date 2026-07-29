//
//  LyricsFailedView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/3.
//

import SwiftUI

struct LyricsFailedView: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Text("歌词加载失败")
                .font(.font32)
                .foregroundStyle(Color.textSecondaryOnDark)
                .lineLimit(1)

            Button(action: onRetry) {
                Text("刷新")
                    .font(.font20)
                    .foregroundStyle(Color.textPrimaryOnDark)
                    .frame(width: 96, height: 42)
                    .overlay {
                        Capsule()
                            .stroke(Color.textSecondaryOnDark, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, minHeight: 360, alignment: .center)
    }
}
