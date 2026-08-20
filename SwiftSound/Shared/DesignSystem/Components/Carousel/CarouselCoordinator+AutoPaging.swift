//
//  CarouselCoordinator+AutoPaging.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/20.
//

extension CarouselCoordinator {
    /// 使用可取消的 Swift Concurrency 任务替代 Timer，视图离开层级时会自动停止。
    func runAutoPagingLoop() async {
        guard let interval = autoPagingInterval, hasMultiplePages, interval > 0 else { return }

        let sleepNanoseconds = UInt64((max(interval, 1) * 1_000_000_000).rounded())
        while !Task.isCancelled {
            try? await Task.sleep(nanoseconds: sleepNanoseconds)
            guard !Task.isCancelled else { return }
            guard let interval = autoPagingInterval, interval > 0, hasMultiplePages else { return }
            movePage(by: 1)
        }
    }
}
