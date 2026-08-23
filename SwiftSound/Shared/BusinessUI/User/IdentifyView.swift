//
//  IdentifyView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import SwiftUI

struct IdentifyView: View {
    let identify: Identify

    var body: some View {
        HStack(spacing: 0) {
            Avatar(url: URL(string: identify.imageUrl), size: Layout.size)
            Text(identify.imageDesc)
                .font(.font12)
                .foregroundStyle(Color.accentPrimary)
                .padding(.horizontal, Layout.padding)
        }
        .background(
            Capsule(style: .continuous)
                .stroke(Color.accentPrimary.opacity(0.1), lineWidth: 1)
                .fill(Color.accentPrimary.opacity(0.08))
        )
    }
}

private extension IdentifyView {
    enum Layout {
        static let size: CGFloat = 18
        static let padding: CGFloat = 5
    }
}

#Preview {
    IdentifyView(identify: .preview)
        .padding()
}
