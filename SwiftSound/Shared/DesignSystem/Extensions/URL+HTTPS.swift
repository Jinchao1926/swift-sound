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

    nonisolated func sizedImageURL(_ size: Int?) -> URL {
        guard let size, size > 0,
              var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }

        guard !components.hasThumbnailParameter else {
            return self
        }

        var queryItems = components.queryItems ?? []
        queryItems.removeAll { $0.name == "param" }
        queryItems.append(URLQueryItem(name: "param", value: "\(size)y\(size)"))
        components.queryItems = queryItems

        return components.url ?? self
    }
}

private extension URLComponents {
    // eg: banner https://p1.music.126.net/FKvlXkgMtQQaT-jUDM8nKQ==/109951173132156183.jpg?imageView=1&thumbnail=800y800&enlarge=1%7CimageView=1&watermark&type=1&image=b2JqL3c1bkRrTUtRd3JMRGpEekNtOE9tLzc5ODU4ODQ1MDcxL2Q1NTUvMjAyNjMyNzE1NDY1NS94NzQ1MTc3NzI3NjAxNTI1OS5wbmc=&dx=0&dy=0%7Cwatermark&type=1&image=b2JqL3dvbkRsc0tVd3JMQ2xHakNtOEt4LzI3NjEwNDk3MDYyL2VlOTMvOTIxYS82NjE4LzdhMDc5ZDg0NTYyMDAwZmVkZWJmMjVjYjE4NjhkOWEzLnBuZw==&dx=0&dy=0%7CimageView=1
    nonisolated var hasThumbnailParameter: Bool {
        [percentEncodedQuery, query]
            .compactMap { $0 }
            .contains { query in
                query.range(of: "thumbnail=", options: .caseInsensitive) != nil
            }
    }
}
