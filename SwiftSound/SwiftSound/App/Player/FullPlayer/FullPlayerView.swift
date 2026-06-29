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
            playerModeBar
            songContent

            PlayerBarView(
                model: model,
                callback: callback,
                style: theme.playerBarStyle,
                onActivate: onCollapse
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.background)
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
    
    private var playerModeBar: some View {
        HStack {
            Spacer()
            
        }
        .frame(height: Layout.playerModeBarHeight)
        .frame(maxWidth: .infinity)
    }
    
    private var songContent: some View {
        // TODO: 左边唱片图片，右边歌曲内容
        // spacing 间距在屏幕尺寸变化时有所不同，比如最小时100，最大时208
        HStack {
            // TODO: 需要适配大背景图
            // 还需要二次封装，支持上方的 pointer（播放的时候 pointer 会移动到 Cover 上）
            SongCoverImage(song: model.song)
            
            // 右边主要内容区域，先不实现
            // 包含歌曲信息/歌词/相似歌曲等
        }
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
        
        static let playerModeBarHeight: CGFloat = 100
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
