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
        .ignoresSafeArea(edges: .top)   // important
        .task(id: model.song.id) {
            await updateThemeColor()
        }
    }

    private var header: some View {
        HStack {
            Button(action: onCollapse) {
                Image(systemName: "chevron.down")
                    .font(.font18)
                    .foregroundStyle(.white)
                    .frame(width: Layout.collapseButtonSize, height: Layout.collapseButtonSize)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.leading, Layout.collapseButtonLeadingInset)
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
        static let collapseButtonSize: CGFloat = 34
        static let collapseButtonLeadingInset: CGFloat = 76
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
