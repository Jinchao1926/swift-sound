//
//  URL+HTTPS.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/25.
//

import Foundation

extension URL {
    nonisolated var httpsURL: URL {
        guard scheme == "http",
              var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }

        components.scheme = "https"
        return components.url ?? self
    }
}
