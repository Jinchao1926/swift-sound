//
//  FloatingVolumePanelPresenter.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/6.
//

import AppKit
import SwiftUI

// MARK: - FloatingVolumePanelPresenter
struct FloatingVolumePanelPresenter: NSViewRepresentable {
    @Binding var isPresented: Bool
    let volume: Double
    let isMuted: Bool
    let onSetVolume: (Double) -> Void
    let onEditingChanged: (Bool) -> Void
    let onPanelHover: (Bool) -> Void

    @Environment(\.playerBarStyle) private var style

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        context.coordinator.anchorView = view
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        context.coordinator.update(
            isPresented: isPresented,
            volume: volume,
            isMuted: isMuted,
            style: style,
            onSetVolume: onSetVolume,
            onEditingChanged: onEditingChanged,
            onPanelHover: onPanelHover
        )
    }

    static func dismantleNSView(_ nsView: NSView, coordinator: Coordinator) {
        coordinator.closePanel()
    }

    // MARK: - Coordinator
    final class Coordinator {
        weak var anchorView: NSView?

        private let panel = VolumePanelWindow()
        private let contentView = FloatingVolumePanelContentView()
        private var hostingView: TransparentHostingView?

        init() {
            contentView.configureForTransparentRendering()
            panel.setFrame(CGRect(origin: .zero, size: VolumePanelLayout.contentSize), display: false)
            panel.contentView = contentView
        }

        func update(
            isPresented: Bool,
            volume: Double,
            isMuted: Bool,
            style: PlayerBarStyle,
            onSetVolume: @escaping (Double) -> Void,
            onEditingChanged: @escaping (Bool) -> Void,
            onPanelHover: @escaping (Bool) -> Void
        ) {
            let rootView = AnyView(
                VolumePanel(
                    volume: volume,
                    isMuted: isMuted,
                    onSetVolume: onSetVolume,
                    onEditingChanged: onEditingChanged
                )
                .environment(\.playerBarStyle, style)
                .tint(.accentPrimary)
                .accentColor(.accentPrimary)
                .background(Color.clear)
            )

            contentView.onHoverChange = onPanelHover
            contentView.panelBackgroundColor = style.volumePanelNSBackgroundColor

            if let hostingView {
                hostingView.rootView = rootView
            } else {
                installHostingView(rootView: rootView)
            }

            if isPresented {
                showPanel()
            } else {
                closePanel()
            }
        }

        func closePanel() {
            panel.parent?.removeChildWindow(panel)
            panel.orderOut(nil)
        }

        private func installHostingView(rootView: AnyView) {
            let hostingView = TransparentHostingView(rootView: rootView)
            self.hostingView = hostingView

            contentView.addSubview(hostingView)
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                [
                    hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ]
            )
        }

        private func showPanel() {
            guard let anchorView, let window = anchorView.window else { return }

            panel.setFrame(panelFrame(anchoredTo: anchorView, in: window), display: false)

            if !panel.isVisible {
                // 作为播放器窗口的 child window，避免音量浮层飘到其他 App 上方。
                window.addChildWindow(panel, ordered: .above)
                panel.orderFront(nil)
            }
        }

        private func panelFrame(anchoredTo anchorView: NSView, in window: NSWindow) -> CGRect {
            // presenter 挂在 SwiftUI background 上，自身可能是 zero-size；此时用 superview 近似按钮区域。
            let anchorBounds = anchorView.bounds.isEmpty
                ? (anchorView.superview?.bounds ?? .zero)
                : anchorView.bounds
            let anchorRectInWindow = anchorView.convert(anchorBounds, to: nil)
            let anchorRectOnScreen = window.convertToScreen(anchorRectInWindow)
            return CGRect(
                x: anchorRectOnScreen.midX - VolumePanelLayout.contentSize.width / 2,
                y: anchorRectOnScreen.maxY + Layout.verticalGap - VolumePanelLayout.shadowTopPadding,
                width: VolumePanelLayout.contentSize.width,
                height: VolumePanelLayout.contentSize.height
            )
        }

        private enum Layout {
            static let verticalGap: CGFloat = 4
        }
    }
}

// MARK: - VolumePanelWindow
private final class VolumePanelWindow: NSPanel {
    init() {
        super.init(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        backgroundColor = .clear
        hasShadow = false
        isOpaque = false
        isReleasedWhenClosed = false
        acceptsMouseMovedEvents = true
        level = .floating
        collectionBehavior = [.transient, .fullScreenAuxiliary]
    }
}

// MARK: - FloatingVolumePanelContentView
private final class FloatingVolumePanelContentView: NSView {
    var onHoverChange: ((Bool) -> Void)?
    var panelBackgroundColor = NSColor.white {
        didSet {
            needsDisplay = true
        }
    }

    override var isFlipped: Bool { true }
    override var isOpaque: Bool { false }

    func configureForTransparentRendering() {
        canDrawSubviewsIntoLayer = true
        frame = CGRect(origin: .zero, size: VolumePanelLayout.contentSize)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        layer?.isOpaque = false
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current else { return }

        context.saveGraphicsState()
        panelShadow.set()

        let path = bubblePath(in: bounds)
        panelBackgroundColor.setFill()
        path.fill()
        context.restoreGraphicsState()

        NSColor.black.withAlphaComponent(0.04).setStroke()
        path.lineWidth = 0.5
        path.stroke()
    }

    private var panelShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(Layout.shadowOpacity)
        shadow.shadowBlurRadius = Layout.shadowBlurRadius
        shadow.shadowOffset = Layout.shadowOffset
        return shadow
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        for trackingArea in trackingAreas {
            removeTrackingArea(trackingArea)
        }

        // 在 AppKit 根视图统一判断鼠标是否在浮层内，避免 SwiftUI 子视图打断 hover 状态。
        addTrackingArea(
            NSTrackingArea(
                rect: bounds,
                options: [.activeAlways, .inVisibleRect, .mouseEnteredAndExited],
                owner: self,
                userInfo: nil
            )
        )
    }

    override func mouseEntered(with event: NSEvent) {
        onHoverChange?(true)
    }

    override func mouseExited(with event: NSEvent) {
        onHoverChange?(false)
    }

    private func bubblePath(in rect: CGRect) -> NSBezierPath {
        // 背景和阴影必须在 AppKit 根视图绘制。SwiftUI shadow 会被 hosting/window bounds 裁切成矩形块。
        let cornerRadius = VolumePanelLayout.panelCornerRadius
        let arrowHalfWidth = VolumePanelLayout.arrowSize / 2
        let arrowHeight = VolumePanelLayout.arrowSize / 2
        let bubbleRect = CGRect(
            x: rect.minX + VolumePanelLayout.shadowHorizontalPadding,
            y: rect.minY + VolumePanelLayout.shadowTopPadding,
            width: VolumePanelLayout.panelWidth,
            height: VolumePanelLayout.bubbleHeight
        )
        let panelMaxY = bubbleRect.minY + VolumePanelLayout.panelHeight
        let arrowLeftX = bubbleRect.midX - arrowHalfWidth
        let arrowRightX = bubbleRect.midX + arrowHalfWidth

        let path = NSBezierPath()
        path.move(to: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.minY))
        path.line(to: CGPoint(x: bubbleRect.maxX - cornerRadius, y: bubbleRect.minY))
        path.curve(
            to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.minY + cornerRadius),
            controlPoint1: CGPoint(x: bubbleRect.maxX, y: bubbleRect.minY),
            controlPoint2: CGPoint(x: bubbleRect.maxX, y: bubbleRect.minY)
        )
        path.line(to: CGPoint(x: bubbleRect.maxX, y: panelMaxY - cornerRadius))
        path.curve(
            to: CGPoint(x: bubbleRect.maxX - cornerRadius, y: panelMaxY),
            controlPoint1: CGPoint(x: bubbleRect.maxX, y: panelMaxY),
            controlPoint2: CGPoint(x: bubbleRect.maxX, y: panelMaxY)
        )
        path.line(to: CGPoint(x: arrowRightX, y: panelMaxY))
        path.line(to: CGPoint(x: bubbleRect.midX, y: panelMaxY + arrowHeight))
        path.line(to: CGPoint(x: arrowLeftX, y: panelMaxY))
        path.line(to: CGPoint(x: bubbleRect.minX + cornerRadius, y: panelMaxY))
        path.curve(
            to: CGPoint(x: bubbleRect.minX, y: panelMaxY - cornerRadius),
            controlPoint1: CGPoint(x: bubbleRect.minX, y: panelMaxY),
            controlPoint2: CGPoint(x: bubbleRect.minX, y: panelMaxY)
        )
        path.line(to: CGPoint(x: bubbleRect.minX, y: bubbleRect.minY + cornerRadius))
        path.curve(
            to: CGPoint(x: bubbleRect.minX + cornerRadius, y: bubbleRect.minY),
            controlPoint1: CGPoint(x: bubbleRect.minX, y: bubbleRect.minY),
            controlPoint2: CGPoint(x: bubbleRect.minX, y: bubbleRect.minY)
        )
        path.close()

        return path
    }

    private enum Layout {
        static let shadowOpacity: CGFloat = 0.14
        static let shadowBlurRadius: CGFloat = 12
        static let shadowOffset = CGSize(width: 0, height: -4)
    }
}

// MARK: - PlayerBarStyle Bridge
private extension PlayerBarStyle {
    var volumePanelNSBackgroundColor: NSColor {
        isDark
            ? NSColor(
                red: CGFloat(0x34) / 255,
                green: CGFloat(0x34) / 255,
                blue: CGFloat(0x3E) / 255,
                alpha: 1
            )
            : .white
    }
}

// MARK: - TransparentHostingView
private final class TransparentHostingView: NSHostingView<AnyView> {
    override var isOpaque: Bool { false }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        makeTransparent()
    }

    override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        makeTransparent()
    }

    private func makeTransparent() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        layer?.isOpaque = false
    }
}
