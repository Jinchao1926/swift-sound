//
//  VIPLevelView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import SwiftUI

struct VIPLevelView: View {
    var body: some View {
        HStack(spacing: Layout.spacing) {
            Color.accentPrimary
                .frame(width: Layout.size, height: Layout.size)
                .overlay {
                    Image("cover")
                }
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 1)
                )
                .zIndex(1)

            Text("VIP")
                .font(.font10.weight(.semibold))
                .foregroundStyle(Color(hex: 0xF0DAD6))
                .padding(.leading, Layout.textLeading)
                .padding(.trailing, Layout.textTrailing)
                .frame(height: Layout.textHeight)
                .background(
                    Capsule()
                        .fill(Color(hex: 0x2D2828))
                )
        }
    }
}

private extension VIPLevelView {
    enum Layout {
        static let size: CGFloat = 18
        static let spacing: CGFloat = -8
        static let textLeading: CGFloat = 12
        static let textTrailing: CGFloat = 6
        static let textHeight: CGFloat = 14
    }
}

#Preview {
    VIPLevelView()
        .padding()
}
