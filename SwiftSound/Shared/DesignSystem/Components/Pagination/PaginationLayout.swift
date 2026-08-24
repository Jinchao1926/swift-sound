//
//  PaginationLayout.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/24.
//

import SwiftUI

enum PaginationLayout {
    // MARK: - Control

    enum Control {
        static let itemSpacing: CGFloat = 10
        static let itemWidth: CGFloat = 30
        static let itemHeight: CGFloat = 36
    }

    // MARK: - Page Range

    enum PageRange {
        /// 页数不超过此值时，完整展示所有页码。
        static let maxPageCountWithoutEllipsis = 8

        /// 当前页靠近首尾时，连续展示的页码数量。
        static let boundaryPageCount = 6

        /// 当前页进入首尾区域时，切换为边界页码布局的阈值。
        static let boundaryThreshold = 4

        /// 中间页码布局中，当前页左右两侧各展示的页数。
        static let neighborRadius = 2
    }

    // MARK: - Jump Input

    enum JumpInput {
        static let itemSpacing: CGFloat = 8
        static let fieldWidth: CGFloat = 32
        static let fieldHeight: CGFloat = 36
        static let fieldPadding: CGFloat = 6
        static let fieldCornerRadius: CGFloat = 8
    }
}
