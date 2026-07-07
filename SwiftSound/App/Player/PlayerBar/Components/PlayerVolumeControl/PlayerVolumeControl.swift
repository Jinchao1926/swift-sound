//
//  PlayerVolumeControl.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/26.
//

import SwiftUI

// MARK: - PlayerVolumeControl
/*
 PlayerVolumeControl 只负责音量按钮和浮层显示状态：
 - PlayerIconButton：显示当前音量/静音图标，点击时切换静音并保持浮层显示。
 - FloatingVolumePanelPresenter：挂在按钮 background 上，负责把 SwiftUI 内容桥接到独立的 AppKit NSPanel。
 - VolumePanel：浮层内部的 SwiftUI 内容，只负责 slider、百分比文字和音量回调。

 事件流：
 1. button hover 进入时，PlayerVolumeControl 将 isPanelPresented 置为 true。
 2. FloatingVolumePanelPresenter 监听 isPanelPresented，在按钮上方显示/隐藏 NSPanel。
 3. VolumePanel 的 slider 拖动通过 onSetVolume 回传音量，通过 onEditingChanged 告诉外层“正在拖动”。
 4. AppKit 根视图统一监听 panel hover，通过 onPanelHover 回传给 PlayerVolumeControl。

 关闭规则：
 浮层只有在鼠标不在按钮、不在浮层、并且没有正在拖动 slider 时才会延迟关闭。
 这样可以避免鼠标从按钮移动到独立 NSPanel 的短暂空隙导致浮层闪退。
 */
struct PlayerVolumeControl: View {
    let volume: Double
    let isMuted: Bool
    let onSetVolume: (Double) -> Void
    let onToggleMute: () -> Void

    // 浮层是否关闭由三个状态共同决定：按钮 hover、浮层 hover、Slider 拖动中。
    @State private var isHoveringButton = false
    @State private var isHoveringPanel = false
    @State private var isEditingVolume = false
    @State private var isPanelPresented = false
    @State private var closeTask: Task<Void, Never>?

    var body: some View {
        PlayerIconButton(systemName: iconName, action: toggleMute)
            .help(isMuted ? "取消静音" : "静音")
            .onHover { updateButtonHover($0) }
            .background(panelPresenter)
            .onDisappear {
                closeTask?.cancel()
                isPanelPresented = false
            }
    }

    private var panelPresenter: some View {
        FloatingVolumePanelPresenter(
            isPresented: $isPanelPresented,
            volume: volume,
            isMuted: isMuted,
            onSetVolume: onSetVolume,
            onEditingChanged: updateVolumeEditing,
            onPanelHover: updatePanelHover
        )
    }

    // MARK: Private
    private var iconName: String {
        if isMuted || volume == 0 {
            return "speaker.slash"
        }
        if volume < 0.3 {
            return "speaker.wave.1"
        }
        if volume < 0.6 {
            return "speaker.wave.2"
        }
        return "speaker.wave.3"
    }

    private var shouldKeepPanelPresented: Bool {
        isHoveringButton || isHoveringPanel || isEditingVolume
    }

    private func toggleMute() {
        onToggleMute()
        presentPanel()
    }

    private func updateButtonHover(_ isHovering: Bool) {
        isHoveringButton = isHovering
        updatePanelPresentation(isActive: isHovering)
    }

    private func updatePanelHover(_ isHovering: Bool) {
        isHoveringPanel = isHovering
        updatePanelPresentation(isActive: isHovering)
    }

    private func updateVolumeEditing(_ isEditing: Bool) {
        isEditingVolume = isEditing
        updatePanelPresentation(isActive: isEditing)
    }

    private func updatePanelPresentation(isActive: Bool) {
        if isActive {
            presentPanel()
        } else {
            schedulePanelClose()
        }
    }

    private func presentPanel() {
        closeTask?.cancel()
        closeTask = nil
        isPanelPresented = true
    }

    private func schedulePanelClose() {
        closeTask?.cancel()
        closeTask = Task { @MainActor in
            do {
                try await Task.sleep(for: .milliseconds(120))
            } catch {
                return
            }

            // 鼠标从按钮移动到独立浮层窗口时会短暂离开按钮区域，延迟关闭可以跨过这个间隙。
            if !shouldKeepPanelPresented {
                isPanelPresented = false
            }
        }
    }
}

#Preview {
    @Previewable @State var volume = 0.34
    @Previewable @State var isMuted = false

    HStack(spacing: 0) {
        VStack {
            Spacer()
            PlayerVolumeControl(
                volume: volume,
                isMuted: isMuted,
                onSetVolume: {
                    volume = $0
                    isMuted = $0 == 0
                },
                onToggleMute: {
                    isMuted.toggle()
                }
            )
            .padding(20)
        }
        .frame(width: 100, height: 420)

        let style = PlayerBarStyle.fullPlayer(themeColor: Color.yellow)
        VStack {
            Spacer()
            PlayerVolumeControl(
                volume: volume,
                isMuted: isMuted,
                onSetVolume: {
                    volume = $0
                    isMuted = $0 == 0
                },
                onToggleMute: {
                    isMuted.toggle()
                }
            )
            .padding(20)
        }
        .frame(width: 100, height: 420)
        .background(style.backgroundColor)
        .environment(\.playerBarStyle, style)
    }
}
