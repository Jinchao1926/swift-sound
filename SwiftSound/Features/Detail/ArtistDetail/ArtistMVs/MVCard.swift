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
        ZStack {
            RemoteImage(url: URL(string: mv.imgurl), size: nil)
                .frame(width: Layout.width, height: Layout.coverHeight)

            VStack {
                HStack(spacing: Layout.badgeSpacing) {
                    Spacer()
                    Image(systemName: "headphones")
                        .font(.font14)
                    Text(mv.playCount.abbreviatedCountText)
                        .font(.font14)
                        .fontWeight(.semibold)
                }

                Spacer()

                HStack {
                    Spacer()
                    Text(TimeInterval(mv.duration).millisecondsMinuteSecondText)
                        .font(.font12)
                }
            }
            .foregroundStyle(Color.textPrimaryOnDark)
            .padding(Layout.overlayPadding)

            if isHovering {
                Color.black.opacity(0.28)
                playIcon
            }
        }
        .frame(width: Layout.width, height: Layout.coverHeight)
        .rounded(radius: Layout.radius)
    }

    private var title: some View {
        Text(mv.name)
            .font(.font14)
            .foregroundStyle(Color.textPrimary)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(Layout.titleMargin)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var playIcon: some View {
        Image(systemName: "play.fill")
            .font(.font24)
            .foregroundStyle(Color.white)
            .frame(width: Layout.playIconSize, height: Layout.playIconSize)
    }
}

private extension MVCard {
    enum Layout {
        static let width: CGFloat = 240
        static let coverHeight: CGFloat = 140
        static let radius: CGFloat = 6

        static let overlayPadding: CGFloat = 8
        static let badgeSpacing: CGFloat = 2

        static let titleMargin: CGFloat = 10
        static let playIconSize: CGFloat = 32
    }
}

#Preview {
    VStack {
        MVCard(mv: .preview)
    }
    .padding()
    .background(Color.surfacePrimary)
}
