//
//  PlayableSongCover.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/18.
//

import SwiftUI

struct PlayableSongCover: View {
    let url: URL?
    let controlIcon: PlaybackControl
    let isHovering: Bool
    let onPlay: () -> Void

    init(
        url: URL? = nil,
        controlIcon: PlaybackControl = .play,
        isHovering: Bool = false,
        onPlay: @escaping () -> Void
    ) {
        self.url = url
        self.controlIcon = controlIcon
        self.isHovering = isHovering
        self.onPlay = onPlay
    }

    var body: some View {
        PlayableCoverImage(
            url: url,
            style: .init(
                imageSize: Layout.imageSize,
                cornerRadius: Layout.cornerRadius,
                animatesHoverEffects: true
            ),
            interactionState: .init(isHovering: isHovering, icon: controlIcon),
            onControlTap: onPlay
        )
    }

    enum Layout {
        static let imageSize: CGFloat = 65
        static let cornerRadius: CGFloat = 8
    }
}

#Preview {
    @Previewable @State var isHovering = false

    VStack {
        PlayableSongCover(isHovering: isHovering) {
            // ...
        }
    }
    .padding()
    .onHover { isHovering = $0 }
}
