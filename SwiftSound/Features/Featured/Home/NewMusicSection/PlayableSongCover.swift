//
//  PlayableSongCover.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/18.
//

import SwiftUI

struct PlayableSongCover: View {
    let url: URL?
    let controlIcon: PlayableCoverImage.ControlIcon
    let isControlVisible: Bool
    let onPlay: () -> Void

    init(
        url: URL? = nil,
        cornerRadius: CGFloat = Layout.cornerRadius,
        controlIcon: PlayableCoverImage.ControlIcon = .play,
        isControlVisible: Bool = false,
        onPlay: @escaping () -> Void
    ) {
        self.url = url
        self.controlIcon = controlIcon
        self.isControlVisible = isControlVisible
        self.onPlay = onPlay
    }

    var body: some View {
        PlayableCoverImage(
            url: url,
            imageSize: Layout.imageSize,
            cornerRadius: Layout.cornerRadius,
            controlIcon: controlIcon,
            isControlVisible: isControlVisible,
            onControlTap: onPlay
        )
    }

    enum Layout {
        static let imageSize: CGFloat = 65
        static let cornerRadius: CGFloat = 8
    }
}

#Preview {
    PlayableSongCover {
        // ...
    }
    .padding()
}
