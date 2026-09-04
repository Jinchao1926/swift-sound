//
//  UserRadioCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI

struct UserRadioCard: View {
    let radio: Radio
    let onPlay: () -> Void

    @State private var isHovering = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            radioCover
            radioInfo
        }
        .background(isHovering ? Color.white : Color.clear)
        .rounded()
        .onHover { isHovering = $0 }
    }

    private var radioCover: some View {
        RemoteImage(url: radio.coverURL)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topTrailing) {
                if radio.playCount > 0 {
                    PlayCountBadge(count: radio.playCount, fontSize: 14)
                        .padding(Layout.coverOverlayInset)
                }
            }
            .playbackOverlay(
                configuration: .init(
                    placement: .bottomTrailing(inset: Layout.coverOverlayInset),
                    buttonSize: Layout.playbackButtonSize,
                    iconFont: .font24
                ),
                isExternalHovering: isHovering,
                onPlaybackTap: onPlay
            )
            .rounded(radius: Layout.radius)
    }

    private var radioInfo: some View {
        VStack(alignment: .leading, spacing: Layout.infoTextSpacing) {
            Text(radio.name)
                .font(.font13)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)

            Text("声音: \(radio.programCount)")
                .font(.font13)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
        }
        .padding(Layout.infoPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension UserRadioCard {
    enum Layout {
        static let radius: CGFloat = 8
        static let infoTextSpacing: CGFloat = 4
        static let infoPadding: CGFloat = 6
        static let coverOverlayInset: CGFloat = 12
        static let playbackButtonSize: CGFloat = 24
    }
}

#Preview {
    UserRadioCard(radio: .preview) {}
        .frame(width: 178)
        .padding()
        .background(Color.surfacePrimary)
}
