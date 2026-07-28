//
//  AppRouter.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/6/13.
//

import Foundation
import Combine

/// 应用内的全局路由历史。
///
/// 这里没有使用 `NavigationStack(path:)` 来保存历史，是因为 SwiftUI 的
/// `NavigationStack` 会把每一次 path 变化都当成新的 destination 页面实例。
/// 对 SwiftSound 来说，一级 tab 和二级 tab 都需要进入同一条“返回历史”，
/// 但二级 tab 切换不应该导致详情页 shell、header 或 `@StateObject` 被重建。
///
/// 因此路由层自己维护浏览器式历史：
/// - `backStack` 记录过去访问过的完整 `AppRoute`
/// - `currentRoute` 表示当前正在展示的页面
/// - 页面容器只根据 `currentRoute` 渲染当前页面
///
/// 这样可以同时满足两个目标：
/// 1. 一级/二级路由切换都能通过返回按钮回到上一次 route
/// 2. 页面身份可以由容器单独控制，例如歌手详情页按 artist id 稳定复用
final class AppRouter: ObservableObject {
    @Published private(set) var currentRoute: AppRoute
    @Published private var backStack: [AppRoute] = []

    init(initialRoute: AppRoute = .featured()) {
        self.currentRoute = initialRoute
    }

    var routeStack: [AppRoute] {
        backStack + [currentRoute]
    }

    var canGoBack: Bool {
        !backStack.isEmpty
    }

    /// 回到上一次访问的完整路由，包括一级路由和二级 tab 路由。
    func goBack() {
        guard let previousRoute = backStack.popLast() else { return }
        currentRoute = previousRoute
    }

    /// 用于面包屑跳回历史中的某个路由，并丢弃它之后的历史记录。
    func navigateBack(to route: AppRoute) {
        guard route != currentRoute else { return }

        guard let index = backStack.lastIndex(of: route) else { return }
        backStack.removeSubrange(index...)
        currentRoute = route
    }

    /// 进入新路由时，把当前路由压入历史栈，再切换当前展示页面。
    func navigate(to route: AppRoute) {
        guard route != currentRoute else { return }
        backStack.append(currentRoute)
        currentRoute = route
    }

    func navigate<Route: SecondaryRouteProtocol>(to route: Route) {
        navigate(to: route.destinationRoute)
    }
}
