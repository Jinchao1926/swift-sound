//
//  APIClientProtocol.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Foundation

nonisolated protocol APIClientProtocol {
    func request<Request: APIRequest>(_ request: Request) async throws -> Request.Response
}
