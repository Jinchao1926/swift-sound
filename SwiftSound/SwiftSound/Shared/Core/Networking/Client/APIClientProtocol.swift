//
//  APIClientProtocol.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Foundation

protocol APIClientProtocol: Sendable {
    func request<Request: APIRequest>(_ request: Request) async throws -> Request.Response
}
