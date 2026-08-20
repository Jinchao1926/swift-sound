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

private struct CarouselPreviewView: View {
    let item: CarouselPreviewItem

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.blue.opacity(0.2))
            .frame(height: 60)
            .overlay {
                Text(String(item.value))
                    .font(.title)
                    .foregroundStyle(.blue)
            }
    }
}

#Preview {
    VStack {
        Carousel(
            items: [1, 2, 3, 4, 5, 6].map { CarouselPreviewItem(value: $0) },
            configuration: CarouselConfiguration(
                sizing: .flexible(columns: 2)
            )
        ) {
            CarouselPreviewView(item: $0)
        }

        Divider()

        Carousel(
            items: [1, 2, 3].map { CarouselPreviewItem(value: $0) },
            configuration: CarouselConfiguration(
                sizing: .flexible(columns: 2)
            )
        ) {
            CarouselPreviewView(item: $0)
        }

        Divider()

        Carousel(
            items: [1, 2, 3, 4, 5, 6].map { CarouselPreviewItem(value: $0) },
            configuration: CarouselConfiguration(
                sizing: .flexible(columns: 4),
                showsPageIndicators: false,
                pagingBehavior: .bounded,
                autoPaging: .disabled
            )
        ) {
            CarouselPreviewView(item: $0)
        }
    }
    .frame(width: 600)
    .padding()
}
