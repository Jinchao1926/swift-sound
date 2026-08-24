//
//  PaginationJumpControl.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/24.
//

import SwiftUI

struct PaginationJumpControl: View {
    @Binding var pageInput: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: PaginationLayout.JumpInput.itemSpacing) {
            Text("前往")
                .font(.font12.weight(.medium))
                .foregroundStyle(Color.textSecondary)

            TextField("", text: $pageInput)
                .font(.font12.weight(.medium))
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, PaginationLayout.JumpInput.fieldPadding)
                .frame(
                    width: PaginationLayout.JumpInput.fieldWidth,
                    height: PaginationLayout.JumpInput.fieldHeight
                )
                .background(Color.clear)
                .overlay {
                    RoundedRectangle(
                        cornerRadius: PaginationLayout.JumpInput.fieldCornerRadius,
                        style: .continuous
                    )
                    .stroke(Color.divider, lineWidth: 1)
                }
                .textFieldStyle(.plain)
                .disabled(!isEnabled)
                .onChange(of: pageInput) { _, newValue in
                    let numericValue = newValue.filter { $0.isNumber }
                    if numericValue != newValue {
                        pageInput = numericValue
                    }
                }
                .onSubmit(action)

            Text("页")
                .font(.font12.weight(.medium))
                .foregroundStyle(Color.textSecondary)
        }
    }
}
