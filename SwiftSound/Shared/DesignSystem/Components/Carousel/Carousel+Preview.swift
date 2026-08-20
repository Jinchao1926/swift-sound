//
//  Carousel+Preview.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/20.
//

import SwiftUI

private struct CarouselPreviewItem: Identifiable {
    let value: Int
    var id: Int { value }
}

#Preview {
    VStack {
        Carousel(
            items: [1, 2, 3, 4, 5, 6].map { CarouselPreviewItem(value: $0) },
            configuration: CarouselConfiguration(
                sizing: .flexible(columns: 2)
            )
        ) { item in
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.blue.opacity(0.2))
                .overlay {
                    Text(String(item.value))
                        .font(.title)
                        .foregroundStyle(.blue)
                }
        }
        .frame(width: 760, height: 164)
        .padding(10)

        Divider()

        Carousel(
            items: [1, 2, 3, 4, 5, 6].map { CarouselPreviewItem(value: $0) },
            configuration: CarouselConfiguration(
                sizing: .flexible(columns: 4),
                showsPageIndicators: false,
                pagingBehavior: .bounded,
                autoPaging: .disabled
            )
        ) { item in
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.blue.opacity(0.2))
                .overlay {
                    Text(String(item.value))
                        .font(.title)
                        .foregroundStyle(.blue)
                }
        }
        .frame(width: 760, height: 164)
        .padding(10)
    }
}
