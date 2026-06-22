//
//  PlayerProgressTrack.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/20.
//

import SwiftUI

struct PlayerProgressTrack: View {
    let onProgressChange: (Double) -> Void

    @State private var progress: Double
    @State private var isHovering = false
    @State private var isDragging = false
    @State private var dragStartProgress: Double?

    // MARK: - LifeCycle
    init(
        initialProgress: Double = 0,
        onProgressChange: @escaping (Double) -> Void = { _ in }
    ) {
        self.onProgressChange = onProgressChange
        self._progress = State(initialValue: Self.clamped(initialProgress))
    }

    var body: some View {
        GeometryReader { proxy in
            let metrics = LayoutMetrics(width: proxy.size.width, progress: progress, isActive: isActive)

            ZStack(alignment: .topLeading) {
                hoverGradient

                interactiveTrackArea(metrics: metrics)
                    .offset(y: metrics.trackHitAreaOffsetY)

                if isActive {
                    // 绝对定位
                    knob
                        .position(x: metrics.knobCenter.x, y: metrics.knobCenter.y)
                        .onHover { isHovering = $0 }
                        .gesture(knobDragGesture(width: metrics.width))
                        .pointerStyle(.link)

                    // 标签会跟随进度条的 x 轴位置移动
                    timeLabel
                        .position(x: metrics.labelCenter.x, y: metrics.labelCenter.y)
                }
            }
            .animation(.easeOut(duration: 0.12), value: isActive)
        }
        .frame(height: Layout.overlayHeight)
        .contentShape(Rectangle())
    }
}

private extension PlayerProgressTrack {
    var isActive: Bool { isHovering || isDragging }

    var progressText: String {
        let currentSeconds = Int((progress * Layout.duration).rounded())

        return "\(currentSeconds.duration) / \(Int(Layout.duration).duration)"
    }
}

// MARK: - Sub Views
private extension PlayerProgressTrack {
    var hoverGradient: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(0),
                Color.black.opacity(isActive ? 0.18 : 0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: Layout.hoverShadowHeight)
        .allowsHitTesting(false)
    }

    func interactiveTrackArea(metrics: LayoutMetrics) -> some View {
        visualTrack(metrics: metrics)
            .frame(width: metrics.width, height: Layout.hitHeight, alignment: .center)
            .contentShape(Rectangle())
            .onHover { isHovering = $0 }
            .gesture(progressDragGesture(width: metrics.width))
            .pointerStyle(.link)
    }

    func visualTrack(metrics: LayoutMetrics) -> some View {
        ProgressView(value: progress)
            .progressViewStyle(PlayerProgressBarStyle(height: metrics.trackHeight))
            .frame(width: metrics.width, height: Layout.hoverProgressHeight, alignment: .center)
    }

    var knob: some View {
        Circle()
            .fill(Color.white)
            .frame(width: Layout.knobSize, height: Layout.knobSize)
            .shadow(color: Color.black.opacity(0.18), radius: 3, x: 0, y: 1)
    }

    var timeLabel: some View {
        Text(progressText)
            .font(.font14.weight(.semibold))
            .foregroundStyle(Color.textPrimary)
            .contentTransition(.numericText())
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(Color.white)
            )
            .fixedSize()
    }
}

// MARK: - Progress
extension PlayerProgressTrack {
    func progressDragGesture(width: CGFloat, originX: CGFloat = 0) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                isDragging = true
                setProgress(at: originX + value.location.x, width: width, animated: false)
            }
            .onEnded { value in
                setProgress(at: originX + value.location.x, width: width)

                withAnimation(.easeOut(duration: 0.12)) {
                    isDragging = false
                }
            }
    }

    func knobDragGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                isDragging = true

                let startProgress = dragStartProgress ?? progress
                dragStartProgress = startProgress
                setProgress(startProgress + Double(value.translation.width / width), animated: false)
            }
            .onEnded { value in
                let startProgress = dragStartProgress ?? progress

                setProgress(startProgress + Double(value.translation.width / width))
                dragStartProgress = nil

                withAnimation(.easeOut(duration: 0.12)) {
                    isDragging = false
                }
            }
    }

    func setProgress(at xPosition: CGFloat, width: CGFloat, animated: Bool = true) {
        guard width > 0 else { return }

        setProgress(Double(xPosition / width), animated: animated)
    }

    func setProgress(_ progress: Double, animated: Bool = true) {
        let nextProgress = Self.clamped(progress)
        guard nextProgress != self.progress else { return }

        let update = {
            self.progress = nextProgress
        }

        if animated {
            withAnimation(.easeOut(duration: 0.12), update)
        } else {
            update()
        }
        onProgressChange(nextProgress)
    }

    static func clamped(_ progress: Double) -> Double {
        min(max(progress, 0), 1)
    }
}

#Preview {
    PlayerProgressTrack(initialProgress: 0.358)
        .frame(height: 140)
        .padding()
}
