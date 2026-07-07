//
//  LyricsScrollView.swift
//  SwiftSound
//
//  Created by Codex on 2026/7/3.
//

import SwiftUI
import Foundation

struct LyricsScrollView: View {
    let lines: [LyricLine]
    let currentTime: TimeInterval
    let onSeek: (TimeInterval) -> Void

    /// 用户滚动时，当前应该高亮的歌词行
    @State private var manualActiveIndex: Int?
    @State private var isManualScrolling = false
    @State private var isProgrammaticScroll = false
    /// 负责 2 秒后恢复播放同步
    @State private var resumePlaybackSyncTask: Task<Void, Never>?
    /// 负责短时间内屏蔽程序滚动产生的位置变化
    @State private var programmaticScrollTask: Task<Void, Never>?

    var body: some View {
        let playbackActiveIndex = activeLineIndex
        let activeIndex = displayedActiveIndex(playbackActiveIndex: playbackActiveIndex)

        GeometryReader { geometry in
            let activeAnchor = activeScrollAnchor(in: geometry.size.height)

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Layout.lineSpacing) {
                        ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                            LyricsLineView(
                                line: line,
                                distance: distance(from: index, to: activeIndex),
                                showsSeekControl: isManualScrolling && distance(from: index, to: activeIndex) == 0,
                                onSeek: onSeek
                            )
                            .id(index)
                            .background(rowCenterReporter(for: index))
                        }
                    }
                    .padding(.vertical, Layout.verticalContentInset)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .coordinateSpace(name: Layout.scrollCoordinateSpace)
                .onAppear {
                    scroll(to: activeIndex, with: proxy, anchor: activeAnchor, animated: false)
                }
                .onChange(of: playbackActiveIndex) { _, newIndex in
                    guard !isManualScrolling else { return }
                    scroll(to: newIndex, with: proxy, anchor: activeAnchor, animated: true)
                }
                .onChange(of: isManualScrolling) { _, isManualScrolling in
                    guard !isManualScrolling else { return }
                    scroll(to: playbackActiveIndex, with: proxy, anchor: activeAnchor, animated: true)
                }
                .onPreferenceChange(LyricsLineCenterPreferenceKey.self) { rowCenters in
                    updateManualActiveIndex(
                        from: rowCenters,
                        viewportCenterY: geometry.size.height / 2
                    )
                }
                .onDisappear {
                    resumePlaybackSyncTask?.cancel()
                    programmaticScrollTask?.cancel()
                }
            }
        }
    }
}

private extension LyricsScrollView {
    // 播放时间找当前行，二分查找
    var activeLineIndex: Int? {
        guard !lines.isEmpty else { return nil }

        let playbackTime = currentTime * 1000
        var lowerBound = 0
        var upperBound = lines.count

        while lowerBound < upperBound {
            let middleIndex = lowerBound + (upperBound - lowerBound) / 2

            if lines[middleIndex].time <= playbackTime {
                lowerBound = middleIndex + 1
            } else {
                upperBound = middleIndex
            }
        }

        return max(0, lowerBound - 1)
    }

    func displayedActiveIndex(playbackActiveIndex: Int?) -> Int? {
        if isManualScrolling, let manualActiveIndex {
            return manualActiveIndex
        }
        return playbackActiveIndex
    }

    func distance(from index: Int, to activeIndex: Int?) -> Int? {
        guard let activeIndex else { return nil }
        return abs(index - activeIndex)
    }

    func rowCenterReporter(for index: Int) -> some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: LyricsLineCenterPreferenceKey.self,
                value: [index: proxy.frame(in: .named(Layout.scrollCoordinateSpace)).midY]
            )
        }
    }

    func updateManualActiveIndex(from rowCenters: [Int: CGFloat], viewportCenterY: CGFloat) {
        guard !isProgrammaticScroll,
              let centeredIndex = rowCenters.min(by: {
                  abs($0.value - viewportCenterY) < abs($1.value - viewportCenterY)
              })?.key else {
            return
        }

        manualActiveIndex = max(0, centeredIndex - 1)
        isManualScrolling = true
        schedulePlaybackSyncRestore()
    }

    func scroll(to index: Int?, with proxy: ScrollViewProxy, anchor: UnitPoint, animated: Bool) {
        guard let index else { return }

        // 当代码自己 scrollTo 时，行位置也会变化，也会触发 preference 更新。
        // 如果不区分，就会把自动滚动误认为用户滚动。因此每次程序滚动前调用：
        markProgrammaticScroll()

        if animated {
            withAnimation(.easeInOut(duration: 0.28)) {
                proxy.scrollTo(index, anchor: anchor)
            }
        } else {
            proxy.scrollTo(index, anchor: anchor)
        }
    }

    func activeScrollAnchor(in viewportHeight: CGFloat) -> UnitPoint {
        guard viewportHeight > 0 else {
            return .center
        }

        // 手动滚动时高亮“中心行往上一行”
        let activeOffset = LyricsLineView.Layout.rowHeight + Layout.lineSpacing
        let anchorY = ((viewportHeight / 2) - activeOffset) / viewportHeight
        return UnitPoint(x: 0.5, y: min(max(anchorY, 0), 1))
    }

    func markProgrammaticScroll() {
        isProgrammaticScroll = true
        programmaticScrollTask?.cancel()
        programmaticScrollTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(420))
            guard !Task.isCancelled else { return }
            isProgrammaticScroll = false
        }
    }

    func schedulePlaybackSyncRestore() {
        resumePlaybackSyncTask?.cancel()
        resumePlaybackSyncTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled else { return }

            isManualScrolling = false
            manualActiveIndex = nil
        }
    }
}

private extension LyricsScrollView {
    enum Layout {
        static let scrollCoordinateSpace = "songLyricsScroll"
        static let lineSpacing: CGFloat = 18
        static let verticalContentInset: CGFloat = 180
    }
}

private struct LyricsLineCenterPreferenceKey: PreferenceKey {
    static let defaultValue: [Int: CGFloat] = [:]

    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { _, newValue in newValue })
    }
}
