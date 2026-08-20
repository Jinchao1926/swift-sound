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

                genderIcon
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

    @ViewBuilder
    private var genderIcon: some View {
        switch user.gender {
        case .male:
            Image(systemName: "person.fill")
                .font(.font14)
                .foregroundStyle(Color.blue)
        case .female:
            Image(systemName: "person.fill")
                .font(.font14)
                .foregroundStyle(Color.pink)
        case .unknow:
            EmptyView()
        }
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
