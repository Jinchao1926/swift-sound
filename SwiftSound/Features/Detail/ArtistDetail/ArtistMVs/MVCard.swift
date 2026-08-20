//
//  MVCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/3.
//

import SwiftUI

struct MVCard: View {
    let mv: MV

    @State private var isHovering = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            cover
            title
        }
        .background(isHovering ? Color.white : Color.clear)
        .rounded()
        .onHover { isHovering = $0 }
    }

    private var cover: some View {
        Color.clear
            .aspectRatio(Layout.coverAspectRatio, contentMode: .fit)
            .overlay {
                RemoteImage(url: URL(string: mv.imgurl), size: nil)
            }
            .overlay(alignment: .topTrailing) {
                VStack(alignment: .trailing) {
                    PlayCountBadge(count: mv.playCount)
                    Spacer()
                    Text(TimeInterval(mv.duration).formattedMillisecondsMinuteSecond())
                        .font(.font12)
                }
                .foregroundStyle(Color.textPrimaryOnDark)
                .padding(Layout.overlayInset)
            }
            .playbackOverlay(isExternalHovering: isHovering)
            .rounded()
    }

    private var title: some View {
        Text(mv.name)
            .font(.font14)
            .foregroundStyle(Color.textPrimary)
            .lineLimit(1)
            .padding(Layout.titleInset)
    }
}

private extension MVCard {
    enum Layout {
        static let coverAspectRatio: CGFloat = 25 / 14
        static let titleInset: CGFloat = 10
        static let overlayInset: CGFloat = 8
        static let badgeSpacing: CGFloat = 2
    }
}

#Preview {
    VStack {
        MVCard(mv: .preview)
    }
    .frame(width: 240)
    .padding()
    .background(Color.surfacePrimary)
}
