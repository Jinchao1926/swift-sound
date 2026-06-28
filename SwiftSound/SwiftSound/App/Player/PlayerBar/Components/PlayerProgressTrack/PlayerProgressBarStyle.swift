//
//  PlayerProgressBarStyle.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/22.
//

import SwiftUI

struct PlayerProgressBarStyle: ProgressViewStyle {
    let height: CGFloat
    let isActive: Bool

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            let fractionCompleted = (configuration.fractionCompleted ?? 0).clamped(to: 0...1)
            let progressWidth = proxy.size.width * fractionCompleted

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.divider.opacity(0.62))
                    .frame(height: height)

                Capsule()
                    .fill(Color.accentPrimary.opacity(isActive ? 1 : 0.72))
                    .frame(width: progressWidth, height: height)
            }
            .frame(height: proxy.size.height, alignment: .center)
        }
    }
}
