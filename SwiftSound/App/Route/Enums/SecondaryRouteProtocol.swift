//
//  SecondaryRouteProtocol.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation

protocol SecondaryRouteProtocol: Hashable, CaseIterable, Identifiable {
    var destinationRoute: AppRoute { get }

    var title: String { get }
}

extension SecondaryRouteProtocol {
    var id: Self { self }
}
