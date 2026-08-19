//
//  ThemeColorLoader.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/18.
//

import SwiftUI
import Combine

final class ThemeColorLoader: ObservableObject {
    @Published private(set) var color: Color?

    private var currentImageURL: URL?
    private var inFlightRequests: [URL: Task<Color?, Never>] = [:]
    private var resolvedURLs = Set<URL>()
    private var resolvedColors: [URL: Color] = [:]

    func load(from imageURL: URL?, animation: Animation? = nil) async {
        guard let imageURL else {
            currentImageURL = nil
            color = nil
            return
        }

        currentImageURL = imageURL

        // cached url
        if resolvedURLs.contains(imageURL) {
            updateColor(resolvedColors[imageURL], animation: animation)
            return
        }

        color = nil

        // new url
        let request = inFlightRequests[imageURL] ?? {
            let request = Task { await Color.themeColor(from: imageURL) }
            inFlightRequests[imageURL] = request
            return request
        }()
        let loadedColor = await request.value

        inFlightRequests[imageURL] = nil
        resolvedURLs.insert(imageURL)
        if let loadedColor {
            resolvedColors[imageURL] = loadedColor
        }

        guard !Task.isCancelled, currentImageURL == imageURL else { return }

        updateColor(loadedColor, animation: animation)
    }

    private func updateColor(_ color: Color?, animation: Animation?) {
        if let animation {
            withAnimation(animation) {
                self.color = color
            }
        } else {
            self.color = color
        }
    }
}
