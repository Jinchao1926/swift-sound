//
//  SecondaryRouteProtocol.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/16.
//

import Foundation

protocol RouteTabProtocol: Hashable, CaseIterable, Identifiable {
    var title: String { get }
}

extension RouteTabProtocol {
    var id: Self { self }
}

protocol SecondaryRouteProtocol: RouteTabProtocol {
    var destinationRoute: AppRoute { get }
}
