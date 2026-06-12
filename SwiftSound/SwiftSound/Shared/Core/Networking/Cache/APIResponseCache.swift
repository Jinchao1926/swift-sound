//
//  APIResponseCache.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/12.
//

import Foundation

/// Small in-memory cache for decoded API responses.
///
/// It is intentionally scoped to Networking: HTTP caching remains Alamofire /
/// URLSession's job, while this cache avoids decoding and requesting the same
/// typed resource repeatedly within its TTL.
final class APIResponseCache {
    static let shared = APIResponseCache()

    private struct Entry {
        let value: Any
        let expiresAt: Date
    }

    private var storage: [String: Entry] = [:]
    private let lock = NSLock()

    func value<Value>(for key: String, as type: Value.Type = Value.self) -> Value? {
        guard !key.isEmpty else { return nil }

        lock.lock()
        defer { lock.unlock() }

        guard let entry = storage[key] else { return nil }

        if entry.expiresAt <= Date() {
            storage.removeValue(forKey: key)
            return nil
        }

        return entry.value as? Value
    }

    func store<Value>(_ value: Value, for key: String, policy: APICachePolicy) {
        guard let ttl = policy.ttl, !key.isEmpty else { return }

        lock.lock()
        storage[key] = Entry(value: value, expiresAt: Date().addingTimeInterval(ttl))
        lock.unlock()
    }

    func removeValue(for key: String) {
        lock.lock()
        storage.removeValue(forKey: key)
        lock.unlock()
    }

    func removeAll() {
        lock.lock()
        storage.removeAll()
        lock.unlock()
    }
}
