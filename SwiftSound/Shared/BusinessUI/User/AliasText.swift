//
//  AliasText.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/7/27.
//

import SwiftUI

struct AliasText: View {
    let alias: [String]

    var body: some View {
        if let text = formattedText {
            Text(text)
                .font(.font13)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }

    private var formattedText: String? {
        let names = alias
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        guard !names.isEmpty else { return nil }
        return "\(names.joined(separator: " / "))"
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        AliasText(alias: ["JJ Lin", "Wayne Lim"])
        AliasText(alias: [])
        AliasText(alias: ["一个非常非常长的艺人别名", "另一个非常非常长的艺人别名"])
    }
    .padding()
}
