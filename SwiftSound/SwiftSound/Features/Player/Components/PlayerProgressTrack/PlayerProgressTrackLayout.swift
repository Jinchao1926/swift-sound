//
//  PlayerProgressTrackLayout.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

extension PlayerProgressTrack {
    enum Layout {
        // The overlay reserves room above the 6 pt track for the hover scrim and time label.
        static let progressHeight: CGFloat = 3
        static let hoverProgressHeight: CGFloat = 6
        static let hoverShadowHeight: CGFloat = 100
        static let overlayHeight: CGFloat = hoverShadowHeight + hoverProgressHeight

        static let knobSize: CGFloat = 14
        static let hitHeight: CGFloat = knobSize

        static let progressLabelEdgeInset: CGFloat = 72
        static let progressLabelOffset: CGFloat = 30
        static let duration: Double = 239
    }

    struct LayoutMetrics {
        let width: CGFloat
        let knobCenter: CGPoint
        let labelCenter: CGPoint
        let trackHitAreaOffsetY: CGFloat
        let trackHeight: CGFloat

        init(width: CGFloat, progress: Double, isActive: Bool) {
            let progressX = width * CGFloat(progress)

            self.width = width
            self.knobCenter = CGPoint(
                x: progressX,
                y: Layout.hoverShadowHeight + Layout.hoverProgressHeight / 2
            )
            self.labelCenter = CGPoint(
                x: Self.clampedLabelX(progressX, width: width),
                y: Layout.hoverShadowHeight - Layout.progressLabelOffset
            )
            self.trackHitAreaOffsetY = Layout.hoverShadowHeight - (Layout.hitHeight - Layout.hoverProgressHeight) / 2
            self.trackHeight = isActive ? Layout.hoverProgressHeight : Layout.progressHeight
        }

        private static func clampedLabelX(_ xPosition: CGFloat, width: CGFloat) -> CGFloat {
            min(
                max(xPosition, Layout.progressLabelEdgeInset),
                width - Layout.progressLabelEdgeInset
            )
        }
    }
}
