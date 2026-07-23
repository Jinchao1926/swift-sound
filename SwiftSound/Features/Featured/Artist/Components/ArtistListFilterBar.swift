//
//  ArtistListFilterBar.swift
//  SwiftSound
//
//  Created by Codex on 2026/7/23.
//

import SwiftUI

struct ArtistListFilterBar: View {
    let query: ArtistListQuery
    let onAreaSelect: (ArtistArea) -> Void
    let onTypeSelect: (ArtistType) -> Void
    let onInitialSelect: (ArtistInitial) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            filterRow(
                options: ArtistArea.allCases,
                selected: query.area,
                title: \.title,
                action: onAreaSelect
            )

            filterRow(
                options: ArtistType.allCases,
                selected: query.type,
                title: \.title,
                action: onTypeSelect
            )

            initialRow
        }
    }

    private func filterRow<Value>(
        options: [Value],
        selected: Value,
        title: KeyPath<Value, String>,
        action: @escaping (Value) -> Void
    ) -> some View where Value: Equatable & Identifiable {
        HStack(spacing: 14) {
            ForEach(options) { value in
                SelectableCapsule(
                    value[keyPath: title],
                    isSelected: value == selected
                ) {
                    action(value)
                }
            }
        }
    }

    private var initialRow: some View {
        HStack(spacing: 14) {
            ForEach(ArtistInitial.allCases) { initial in
                InitialFilterButton(
                    title: initial.title,
                    isSelected: query.initial == initial
                ) {
                    onInitialSelect(initial)
                }

                if initial == .hot {
                    Rectangle()
                        .fill(Color.divider)
                        .frame(width: 1, height: 16)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

private struct InitialFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.font15)
                .foregroundStyle(isActive ? Color.accentPrimary : Color.textPrimary)
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .pointerStyle(.link)
    }

    private var isActive: Bool {
        isSelected || isHovering
    }
}

#Preview {
    VStack {
        ArtistListFilterBar(
            query: ArtistListQuery(type: .all, area: .all, initial: .hot),
            onAreaSelect: { _ in },
            onTypeSelect: { _ in },
            onInitialSelect: { _ in }
        )
    }
    .frame(width: 700, alignment: .leading)
    .padding()
}
