//
//  SubscriberCard.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/22.
//

import SwiftUI

struct SubscriberCard: View {
    let user: User

    @State private var isHovering = false

    var body: some View {
        VStack(spacing: Layout.contentSpacing) {
            Avatar(url: user.avatarURL)

            HStack(spacing: Layout.userSpacing) {
                Text(user.nickname)
                    .font(.font14)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)

                GenderView(gender: user.gender)
            }

            Text(user.safeSignature)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
        }
        .padding(Layout.inset)
        .onHover { isHovering = $0 }
        .background(
            RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                .fill(isHovering ? .white : .clear)
        )
    }
}

private extension SubscriberCard {
    enum Layout {
        static let inset: CGFloat = 20
        static let cornerRadius: CGFloat = 6

        static let contentSpacing: CGFloat = 10
        static let userSpacing: CGFloat = 2
    }
}

#Preview {
    SubscriberCard(user: .preview)
        .frame(width: 180)
        .padding()
        .background(Color.surfacePrimary)
}
