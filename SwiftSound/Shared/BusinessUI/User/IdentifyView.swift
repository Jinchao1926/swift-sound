//
//  IdentifyView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import SwiftUI

struct IdentifyView: View {
    let identify: Identify

    @StateObject private var themeColorLoader = ThemeColorLoader()
    private var themeColor: Color {
        themeColorLoader.color ?? .accentPrimary
    }

    var body: some View {
        HStack(spacing: 0) {
            RemoteImage(url: identify.imageURL)
                .frame(width: Layout.size, height: Layout.size)
            Text(identify.imageDesc)
                .font(.font12)
                .foregroundStyle(themeColor)
                .padding(.horizontal, Layout.padding)
        }
        .background(
            Capsule(style: .continuous)
                .stroke(themeColor.opacity(0.1), lineWidth: 1)
                .fill(themeColor.opacity(0.35))
        )
        .task(id: identify.id) {
            await themeColorLoader.load(from: identify.imageURL)
        }
    }
}

private extension IdentifyView {
    enum Layout {
        static let size: CGFloat = 18
        static let padding: CGFloat = 5
    }
}

#Preview {
    VStack(alignment: .leading) {
        IdentifyView(identify: .preview)
        IdentifyView(identify: .preview1)
        IdentifyView(identify: .preview2)
        IdentifyView(identify: .preview3)
        IdentifyView(identify: .preview4)
    }
    .padding()
}
