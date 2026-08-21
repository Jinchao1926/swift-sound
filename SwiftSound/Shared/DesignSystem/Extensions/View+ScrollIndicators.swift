//
//  View+ScrollIndicators.swift
//  SwiftSound
//

import SwiftUI

private struct VerticalScrollIndicatorModifier: ViewModifier {
    let hideDelay: Duration
    let minimumOverflow: CGFloat

    @State private var scrollGeometry = VerticalScrollGeometry.zero
    @State private var isScrolling = false
    @State private var isIndicatorVisible = false

    func body(content: Content) -> some View {
        content
            // 原生滚动条在 legacy 样式下会占用内容宽度，因此改用不参与布局的 overlay 指示器。
            .scrollIndicators(.never, axes: .vertical)
            .onScrollPhaseChange { _, phase in
                isScrolling = phase != .idle
                if isScrolling {
                    isIndicatorVisible = true
                }
            }
            .onScrollGeometryChange(for: VerticalScrollGeometry.self) {
                VerticalScrollGeometry($0)
            } action: { _, geometry in
                scrollGeometry = geometry
            }
            .overlay(alignment: .trailing) {
                VerticalScrollIndicator(
                    geometry: scrollGeometry,
                    minimumOverflow: minimumOverflow,
                    isVisible: shouldShowIndicator
                )
            }
            // 滚动重新开始时，变化的 task id 会自动取消尚未完成的隐藏任务。
            .task(id: isScrolling) {
                guard !isScrolling else { return }

                do {
                    try await Task.sleep(for: hideDelay)
                } catch {
                    return
                }

                guard !Task.isCancelled else { return }
                isIndicatorVisible = false
            }
    }

    private var shouldShowIndicator: Bool {
        isIndicatorVisible
            && scrollGeometry.hasScrollableContent(minimumOverflow: minimumOverflow)
    }
}

private struct VerticalScrollIndicator: View {
    let geometry: VerticalScrollGeometry
    let minimumOverflow: CGFloat
    let isVisible: Bool

    var body: some View {
        GeometryReader { proxy in
            if let thumbMetrics = geometry.thumbMetrics(
                trackHeight: proxy.size.height,
                minimumThumbHeight: VerticalScrollIndicatorLayout.minimumThumbHeight,
                minimumOverflow: minimumOverflow
            ) {
                Capsule(style: .continuous)
                    .fill(Color.scrollIndicator)
                    .frame(
                        width: VerticalScrollIndicatorLayout.thickness,
                        height: thumbMetrics.height
                    )
                    .offset(y: thumbMetrics.offsetY)
            }
        }
        .frame(width: VerticalScrollIndicatorLayout.thickness)
        .padding(.trailing, VerticalScrollIndicatorLayout.trackHorizontalInset)
        .opacity(isVisible ? 1 : 0)
        .animation(
            .easeOut(duration: VerticalScrollIndicatorLayout.fadeAnimationDuration),
            value: isVisible
        )
        .allowsHitTesting(false)
    }
}

/// 自绘垂直滚动条所需的最小几何快照，避免保存完整的 `ScrollGeometry`。
private struct VerticalScrollGeometry: Equatable {
    let contentOffsetY: CGFloat
    let contentHeight: CGFloat
    let topContentInset: CGFloat
    let bottomContentInset: CGFloat
    let viewportHeight: CGFloat

    static let zero = VerticalScrollGeometry(
        contentOffsetY: 0,
        contentHeight: 0,
        topContentInset: 0,
        bottomContentInset: 0,
        viewportHeight: 0
    )

    init(_ geometry: ScrollGeometry) {
        contentOffsetY = geometry.contentOffset.y
        contentHeight = geometry.contentSize.height
        topContentInset = geometry.contentInsets.top
        bottomContentInset = geometry.contentInsets.bottom
        viewportHeight = geometry.containerSize.height
    }

    private init(
        contentOffsetY: CGFloat,
        contentHeight: CGFloat,
        topContentInset: CGFloat,
        bottomContentInset: CGFloat,
        viewportHeight: CGFloat
    ) {
        self.contentOffsetY = contentOffsetY
        self.contentHeight = contentHeight
        self.topContentInset = topContentInset
        self.bottomContentInset = bottomContentInset
        self.viewportHeight = viewportHeight
    }

    private var minimumContentOffsetY: CGFloat {
        -topContentInset
    }

    private var maximumContentOffsetY: CGFloat {
        max(
            contentHeight + bottomContentInset - viewportHeight,
            minimumContentOffsetY
        )
    }

    private var scrollableHeight: CGFloat {
        maximumContentOffsetY - minimumContentOffsetY
    }

    /// 只有内容实际超出视口时才需要显示滚动指示器。
    func hasScrollableContent(minimumOverflow: CGFloat) -> Bool {
        scrollableHeight > minimumOverflow
    }

    func thumbMetrics(
        trackHeight: CGFloat,
        minimumThumbHeight: CGFloat,
        minimumOverflow: CGFloat
    ) -> ScrollIndicatorThumbMetrics? {
        guard hasScrollableContent(minimumOverflow: minimumOverflow), trackHeight > 0 else {
            return nil
        }

        // contentInsets 也是可滚动区域的一部分，必须计入滑块高度比例。
        let totalContentHeight = contentHeight + topContentInset + bottomContentInset
        let visibleFraction = (viewportHeight / totalContentHeight).clamped(to: 0...1)
        let thumbHeight = (trackHeight * visibleFraction)
            .clamped(to: min(minimumThumbHeight, trackHeight)...trackHeight)
        let thumbTravel = max(trackHeight - thumbHeight, 0)
        let contentOffsetRange = minimumContentOffsetY...maximumContentOffsetY
        // 回弹会让 contentOffset 暂时越界；钳制后滑块始终停留在轨道范围内。
        let visibleContentOffset = contentOffsetY.clamped(to: contentOffsetRange)
        let scrollProgress = (visibleContentOffset - minimumContentOffsetY) / scrollableHeight

        return ScrollIndicatorThumbMetrics(
            height: thumbHeight,
            offsetY: thumbTravel * scrollProgress
        )
    }
}

private struct ScrollIndicatorThumbMetrics {
    let height: CGFloat
    let offsetY: CGFloat
}

private enum VerticalScrollIndicatorLayout {
    static let thickness: CGFloat = 6
    static let minimumThumbHeight: CGFloat = 32
    static let trackHorizontalInset: CGFloat = 4
    static let fadeAnimationDuration: TimeInterval = 0.3
}

extension View {
    func scrollIndicatorOverlay(
        hideDelay: Duration = .milliseconds(600),
        minimumOverflow: CGFloat = 0.5
    ) -> some View {
        modifier(
            VerticalScrollIndicatorModifier(
                hideDelay: hideDelay,
                minimumOverflow: max(0, minimumOverflow)
            )
        )
    }
}
