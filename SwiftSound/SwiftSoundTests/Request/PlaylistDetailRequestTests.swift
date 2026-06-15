//
//  PlaylistDetailRequestTests.swift
//  SwiftSoundTests
//
//  Created by Jinchao Lin on 2026/6/15.
//

import Foundation
import Testing
@testable import SwiftSound

struct PlaylistDetailRequestTests {

    @Test func buildsPlaylistDetailRequestURL() throws {
        let request = PlaylistDetailRequest(id: 8_159_674_692)
        let baseURL = try #require(URL(string: "https://example.com"))
        let urlRequest = try request.urlRequest(relativeTo: baseURL)

        #expect(urlRequest.url?.absoluteString == "https://example.com/playlist/detail?id=8159674692")
        #expect(urlRequest.httpMethod == "GET")
    }
}
