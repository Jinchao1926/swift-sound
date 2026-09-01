//
//  EmptyStateView.swift
//  SwiftSound
//

import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let title: String

    init(
        systemImage: String = "tray",
        title: String = "空空如也"
    ) {
        self.systemImage = systemImage
        self.title = title
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundStyle(Color.textTertiary.opacity(0.8))

            Text(title)
                .font(.font16)
                .foregroundStyle(Color.textSecondary.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
    }
}

#Preview {
    EmptyStateView()
        .frame(width: 400)
}
