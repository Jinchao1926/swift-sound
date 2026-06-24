//
//  PlayerProgressTrackLayout.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

extension PlayerProgressTrack {
    enum Layout {
        static let progressHeight: CGFloat = 3
        static let hoverProgressHeight: CGFloat = 6
        static let hoverShadowHeight: CGFloat = 100
        static let height: CGFloat = hoverProgressHeight

        static let knobSize: CGFloat = 14
        static let hitHeight: CGFloat = knobSize

        static let progressLabelWidth: CGFloat = 110
        static let progressLabelHeight: CGFloat = 30
        static let progressLabelOffset: CGFloat = 30
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
                y: Layout.hoverProgressHeight / 2
            )
            self.labelCenter = CGPoint(
                x: Self.clampedLabelX(progressX, width: width),
                y: -(Layout.progressLabelOffset + Layout.hoverProgressHeight / 2)
            )
            self.trackHitAreaOffsetY = (Layout.height - Layout.hitHeight) / 2
            self.trackHeight = isActive ? Layout.hoverProgressHeight : Layout.progressHeight
        }

        private static func clampedLabelX(_ xPosition: CGFloat, width: CGFloat) -> CGFloat {
            min(
                max(xPosition, Layout.progressLabelWidth / 2),
                width - Layout.progressLabelWidth / 2
            )
        }
    }
}
