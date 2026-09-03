//
//  SettingPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/1.
//

import SwiftUI
import Combine

struct SettingPage: View {
    @State private var selected: SettingSection = .account

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.spacing) {
            Text("设置")
                .font(.font24)
                .foregroundStyle(Color.textPrimary)

            SelectableTabView(
                items: SettingSection.allCases,
                selectedID: selected.id,
                title: \.rawValue) {
                    selected = $0
                }

            Spacer()
        }
        .padding(.horizontal, Layout.horizontalInset)
        .padding(.bottom, Layout.bottomInset)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension SettingPage {
    enum Layout {
        static let spacing: CGFloat = 25
        static let bottomInset: CGFloat = 60
        static let horizontalInset: CGFloat = 40
    }
}

#Preview {
    SettingPage()
        .frame(width: 800, height: 400)
}
