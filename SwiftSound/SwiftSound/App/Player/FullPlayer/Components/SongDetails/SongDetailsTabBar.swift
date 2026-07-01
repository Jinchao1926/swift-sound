//
//  SongDetailsTabBar.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/1.
//

import SwiftUI

struct SongDetailsTabBar: View {
    @Binding var selectedTab: SongDetailsTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(SongDetailsTab.allCases) { tab in
                SongDetailsTabButton(
                    tab: tab,
                    isSelected: tab == selectedTab
                ) {
                    selectedTab = tab
                }
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.08))
        )
    }
}

private struct SongDetailsTabButton: View {
    let tab: SongDetailsTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(tab.title)
                .font(.font14)
                .foregroundStyle(isSelected ? Color.textPrimaryOnDark : Color.textSecondaryOnDark)
                .padding(.horizontal, 10)
                .frame(height: 25)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.white.opacity(0.12) : Color.clear)
                )
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }
}

#Preview {
    SongDetailsTabBar(selectedTab: .constant(.lyrics))
        .padding()
        .background(Color(hex: 0x151515))
}
