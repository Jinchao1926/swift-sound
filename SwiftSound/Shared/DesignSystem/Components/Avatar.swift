//
//  Avatar.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/5.
//

import SwiftUI

struct Avatar: View {
    let url: URL?
    let size: CGFloat
    let fallbackSystemName: String

    init(
        url: URL?,
        size: CGFloat,
        fallbackSystemName: String = "person"
    ) {
        self.url = url
        self.size = size
        self.fallbackSystemName = fallbackSystemName
    }

    var body: some View {
        Group {
            if let url {
                RemoteImage(url: url, size: nil)
            } else {
                Circle()
                    .fill(Color.surfaceSecondary)
                    .overlay {
                        Image(systemName: fallbackSystemName)
                            .font(.font20)
                            .foregroundStyle(Color.textTertiary)
                    }
            }
        }
        .frame(width: size, height: size)
        .background(Color.surfaceSecondary)
        .clipShape(Circle())
        .overlay {
            Circle()
                .strokeBorder(Color.divider, lineWidth: 1)
        }
    }
}

#Preview {
    HStack {
        Avatar(url: Artist.preview.avatarURL, size: 58)
        Avatar(url: nil, size: 58)
    }
    .padding()
}
