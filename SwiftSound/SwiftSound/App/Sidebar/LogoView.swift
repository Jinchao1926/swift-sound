//
//  LogoView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        HStack(spacing: Layout.logoTitleSpacing) {
            Image("logo-circle")
                .resizable()
                .scaledToFit()
                .frame(width: Layout.logoSize, height: Layout.logoSize)

            Text("网易云音乐")
                .font(.head4)
                .foregroundStyle(Color.textPrimary)
            
            Spacer(minLength: 0)
        }
        .frame(height: Layout.height)
        .padding(.leading, Layout.leadingInset)
        .padding(.bottom, Layout.bottomInset)
        .allowsHitTesting(false)
    }

    private enum Layout {
        static let height: CGFloat = 40
        static let leadingInset: CGFloat = 22
        static let bottomInset: CGFloat = 18
        
        static let logoSize: CGFloat = 24
        static let logoTitleSpacing: CGFloat = 8
    }
}

#Preview {
    LogoView()
        .frame(maxWidth: 203)
}
