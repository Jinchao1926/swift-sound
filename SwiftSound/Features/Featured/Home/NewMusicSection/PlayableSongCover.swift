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
    let onPlay: () -> Void

    init(
        url: URL? = nil,
        cornerRadius: CGFloat = Layout.cornerRadius,
        controlIcon: PlayableCoverImage.ControlIcon = .play,
        onPlay: @escaping () -> Void
    ) {
        self.url = url
        self.controlIcon = controlIcon
        self.onPlay = onPlay
    }

    var body: some View {
        PlayableCoverImage(
            url: url,
            imageSize: Layout.imageSize,
            cornerRadius: Layout.cornerRadius,
            controlIcon: controlIcon,
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
