//
//  SidebarView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/11.
//

import SwiftUI

struct SidebarView: View {
    var body: some View {
        VStack(spacing: 0) {
            LogoView()

            VStack(spacing: 0) {
                ForEach(SidebarSection.allCases) { section in
                    if section != .discover {
                        Divider()
                            .overlay(Color.divider)
                            .padding(.vertical, Layout.dividerVerticalInset)
                    }

                    ForEach(section.routes) { route in
                        SidebarRowView(route: route)
                    }
                }
            }
            .padding(.leading, Layout.leadingInset)
            .padding(.trailing, Layout.trailingInset)

            Spacer(minLength: 0)
        }
        .background(Color.surfaceSecondary)
    }

    private enum Layout {
        static let leadingInset: CGFloat = 22
        static let trailingInset: CGFloat = 16
        static let dividerVerticalInset: CGFloat = 11
    }
}

#Preview {
    SidebarView()
        .frame(width: 203)
        .environmentObject(AppRouter())
}
