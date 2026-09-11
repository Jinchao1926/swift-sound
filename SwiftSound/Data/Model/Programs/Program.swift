//
//  Program.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import Foundation

protocol ProgramProtocol: Identifiable {
    var id: Int { get }
    var name: String { get }
    var serialNum: Int { get }
    var coverUrl: String { get }
    var duration: Int { get } // ms
    var listenerCount: Int { get }
    var radio: Radio { get }
}

extension ProgramProtocol {
    var imageURL: URL? { URL(string: coverUrl) }
}

struct Program: Decodable, ProgramProtocol {
    let id: Int
    let name: String
    let serialNum: Int
    let coverUrl: String
    let duration: Int // ms
    let createTime: Int
    let description: String
    let subscribed: Bool
    let subscribedCount: Int
    let shareCount: Int
    let commentCount: Int
    let listenerCount: Int
    let likedCount: Int
    let trackCount: Int
    let radio: Radio
}
