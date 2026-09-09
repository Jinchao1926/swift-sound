//
//  RadioHostIndexCell.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/9.
//

import SwiftUI

struct RadioHostIndexCell: View {
    let index: Int

    var body: some View {
        VStack {
            Text(String(format: "%02d", index))
                .font(.font12)
                .foregroundStyle(Color.textSecondary)
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
        .frame(width: Layout.iconSize, height: Layout.iconSize)
    }

    private enum Layout {
        static let iconSize: CGFloat = 28
    }
}

#Preview {
    VStack {
        RadioHostIndexCell(index: 1)
    }
    .padding()
}
