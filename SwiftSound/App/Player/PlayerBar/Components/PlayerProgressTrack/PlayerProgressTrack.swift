//
//  PlayerProgressTrack.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/20.
//

import SwiftUI

struct PlayerProgressTrack: View {
    let currentTime: TimeInterval
    let duration: TimeInterval
    let onSeek: (TimeInterval) -> Void

    @Environment(\.playerBarStyle) private var style
    @State private var displayedTime: TimeInterval
    @State private var isHovering = false
    @State private var isDragging = false
    @State private var dragStartTime: TimeInterval?

    // MARK: - LifeCycle
    init(
        currentTime: TimeInterval = 0,
        duration: TimeInterval = 0,
        onSeek: @escaping (TimeInterval) -> Void = { _ in }
    ) {
        self.duration = max(duration, 0)
        self.currentTime = Self.clampedTime(currentTime, duration: self.duration)
        self.onSeek = onSeek
        self._displayedTime = State(initialValue: Self.clampedTime(currentTime, duration: self.duration))
    }

    var body: some View {
        GeometryReader { proxy in
            let metrics = LayoutMetrics(width: proxy.size.width, progress: progress, isActive: isActive)

            ZStack(alignment: .topLeading) {
                if isActive {
                    hoverGradient
                        .offset(y: -Layout.hoverShadowHeight)
                        .allowsHitTesting(false)
                }

                interactiveTrackArea(metrics: metrics)
                    .offset(y: metrics.trackHitAreaOffsetY)

                if isActive {
                    knob
                        .position(x: metrics.knobCenter.x, y: metrics.knobCenter.y)
                        .onHover { isHovering = $0 }
                        .gesture(knobDragGesture(width: metrics.width))
                        .pointerStyle(.link)

                    timeLabel
                        .position(x: metrics.labelCenter.x, y: metrics.labelCenter.y)
                        .allowsHitTesting(false)
                }
            }
            .animation(.easeOut(duration: 0.12), value: isActive)
        }
        .frame(height: Layout.height)
        .onChange(of: currentTime) { _, nextTime in
            guard !isDragging else { return }
            displayedTime = Self.clampedTime(nextTime, duration: duration)
        }
        .onChange(of: duration) { _, nextDuration in
            displayedTime = Self.clampedTime(displayedTime, duration: nextDuration)
        }
    }
}

private extension PlayerProgressTrack {
    var isActive: Bool { isHovering || isDragging }

    var progress: Double {
        Self.progress(currentTime: displayedTime, duration: duration)
    }

    var progressText: String {
        let currentSeconds = Int(displayedTime.rounded())

        return "\(currentSeconds.formattedMinuteSecond()) / \(Int(duration.rounded()).formattedMinuteSecond())"
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
    }

    func interactiveTrackArea(metrics: LayoutMetrics) -> some View {
        visualTrack(metrics: metrics)
            .frame(width: metrics.width, height: Layout.hitHeight, alignment: .bottom)
            .contentShape(Rectangle())
            .onHover { isHovering = $0 }
            .gesture(progressDragGesture(width: metrics.width))
            .pointerStyle(.link)
    }

    func visualTrack(metrics: LayoutMetrics) -> some View {
        ProgressView(value: progress)
            .progressViewStyle(
                PlayerProgressBarStyle(
                    height: metrics.trackHeight,
                    isActive: isActive,
                    progressColor: style.progressColor,
                    trackColor: style.progressTrackColor
                )
            )
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
            .foregroundStyle(style.progressLabelTextColor)
            .contentTransition(.numericText())
            .frame(width: Layout.progressLabelWidth, height: Layout.progressLabelHeight)
            .background(
                Capsule()
                    .fill(style.progressLabelBackgroundColor)
            )
    }
}

// MARK: - Progress
extension PlayerProgressTrack {
    func progressDragGesture(width: CGFloat, originX: CGFloat = 0) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                isDragging = true
                setTime(at: originX + value.location.x, width: width, animated: false)
            }
            .onEnded { value in
                setTime(at: originX + value.location.x, width: width)

                withAnimation(.easeOut(duration: 0.12)) {
                    isDragging = false
                }
            }
    }

    func knobDragGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                isDragging = true

                let startTime = dragStartTime ?? displayedTime
                dragStartTime = startTime
                setTime(startTime + duration * Double(value.translation.width / width), animated: false)
            }
            .onEnded { value in
                let startTime = dragStartTime ?? displayedTime

                setTime(startTime + duration * Double(value.translation.width / width))
                dragStartTime = nil

                withAnimation(.easeOut(duration: 0.12)) {
                    isDragging = false
                }
            }
    }

    func setTime(at xPosition: CGFloat, width: CGFloat, animated: Bool = true) {
        guard width > 0 else { return }

        setTime(duration * Double(xPosition / width), animated: animated)
    }

    func setTime(_ time: TimeInterval, animated: Bool = true) {
        let nextTime = Self.clampedTime(time, duration: duration)
        guard nextTime != displayedTime else { return }

        let update = {
            self.displayedTime = nextTime
        }

        if animated {
            withAnimation(.easeOut(duration: 0.12), update)
        } else {
            update()
        }
        onSeek(nextTime)
    }

    static func clampedTime(_ time: TimeInterval, duration: TimeInterval) -> TimeInterval {
        time.clamped(to: 0...max(duration, 0))
    }

    static func progress(currentTime: TimeInterval, duration: TimeInterval) -> Double {
        guard duration > 0 else { return 0 }

        return (currentTime / duration).clamped(to: 0...1)
    }
}

#Preview {
    PlayerProgressTrack(currentTime: 107, duration: Song.preview.durationTimeInterval)
        .frame(height: 140)

    let style = PlayerBarStyle.fullPlayer(themeColor: Color.yellow)
    VStack {
        PlayerProgressTrack(currentTime: 107, duration: Song.preview.durationTimeInterval)
            .frame(height: 140)
    }
    .background(style.backgroundColor)
    .environment(\.playerBarStyle, style)
}
