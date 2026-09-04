//
//  LoadableFailureView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/4.
//

import SwiftUI

struct LoadableFailureView: View {
    let error: Error
    let retry: (() async -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 28))
                .foregroundStyle(Color.textTertiary)

            Text("加载失败")
                .font(.font16)
                .foregroundStyle(Color.textSecondary)

            if let retry {
                Button("重试") {
                    Task {
                        await retry()
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(error.localizedDescription))
    }
}

#Preview("Failure with Retry") {
    LoadableFailureView(
        error: NSError(
            domain: "SwiftSound.Preview",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "网络连接失败"]
        ),
        retry: {}
    )
    .frame(width: 320)
    .padding()
}

#Preview("Failure without Retry") {
    LoadableFailureView(
        error: NSError(
            domain: "SwiftSound.Preview",
            code: 2,
            userInfo: [NSLocalizedDescriptionKey: "内容加载失败"]
        ),
        retry: nil
    )
    .frame(width: 320)
    .padding()
}
