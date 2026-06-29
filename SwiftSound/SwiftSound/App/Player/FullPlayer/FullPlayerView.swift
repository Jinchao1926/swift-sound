//
//  PlayerView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/24.
//

import SwiftUI

struct FullPlayerView: View {
    let model: PlayerPresentationModel
    let callback: PlayerControlsCallback
    let onCollapse: () -> Void

    @State private var themeColor: Color?

    private var theme: FullPlayerTheme {
        FullPlayerTheme(themeColor: themeColor)
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            Spacer(minLength: 0)

            PlayerBarView(
                model: model,
                callback: callback,
                style: theme.playerBarStyle,
                onActivate: onCollapse
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.background)
        .contentShape(Rectangle())
        .task(id: model.song.id) {
            await updateThemeColor()
        }
    }

    private var header: some View {
        HStack {
            Button(action: onCollapse) {
                Image(systemName: "chevron.down")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.82))
                    .frame(width: Layout.collapseButtonSize, height: Layout.collapseButtonSize)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .help("收起播放器")

            Spacer()
        }
        .padding(.horizontal, Layout.horizontalInset)
        .padding(.top, Layout.topInset)
    }
}

private extension FullPlayerView {
    func updateThemeColor() async {
        themeColor = nil

        let color = await Color.themeColor(from: URL(string: model.song.album.picUrl))
        guard !Task.isCancelled else { return }

        withAnimation(.easeInOut(duration: 0.24)) {
            themeColor = color
        }
    }
}

private extension FullPlayerView {
    enum Layout {
        static let collapseButtonSize: CGFloat = 44
        static let horizontalInset: CGFloat = 36
        static let topInset: CGFloat = 18
    }
}

#Preview {
    FullPlayerView(
        model: .preview(),
        callback: .preview,
        onCollapse: {}
    )
    .frame(width: 1280, height: 800)
}
