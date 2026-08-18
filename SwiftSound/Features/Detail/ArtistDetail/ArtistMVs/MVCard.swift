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
        .frame(width: Layout.width)
        .background(isHovering ? Color.white : Color.clear)
        .rounded(radius: Layout.radius)
        .onHover { isHovering = $0 }
    }

    private var cover: some View {
        RemoteImage(url: URL(string: mv.imgurl), size: nil)
            .frame(width: Layout.width, height: Layout.coverHeight)
            .overlay(alignment: .topTrailing) {
                VStack {
                    PlayCountBadge(count: mv.playCount)
                    Spacer()
                    Text(TimeInterval(mv.duration).formattedMillisecondsMinuteSecond())
                        .font(.font12)
                }
                .foregroundStyle(Color.textPrimaryOnDark)
                .padding(Layout.overlayPadding)
            }
            .playbackOverlay(isExternalHovering: isHovering)
            .rounded(radius: Layout.radius)
    }

    private var title: some View {
        Text(mv.name)
            .font(.font14)
            .foregroundStyle(Color.textPrimary)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(Layout.titlePadding)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension MVCard {
    enum Layout {
        static let width: CGFloat = 240
        static let coverHeight: CGFloat = 140
        static let radius: CGFloat = 6

        static let overlayPadding: CGFloat = 8
        static let badgeSpacing: CGFloat = 2

        static let titlePadding: CGFloat = 10
    }
}

#Preview {
    VStack {
        MVCard(mv: .preview)
    }
    .padding()
    .background(Color.surfacePrimary)
}
