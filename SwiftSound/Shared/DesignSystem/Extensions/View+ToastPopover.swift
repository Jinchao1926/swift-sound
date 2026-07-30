//
//  View+ToastPopover.swift
//  SwiftSound
//
//  Created by Codex on 2026/7/29.
//

import SwiftUI

private struct ToastPopoverModifier<PopoverContent: View>: ViewModifier {
    @Binding var isPresented: Bool

    let autoDismissAfter: Duration
    let arrowEdge: Edge
    let popoverContent: () -> PopoverContent

    func body(content: Content) -> some View {
        content
            .popover(isPresented: $isPresented, arrowEdge: arrowEdge) {
                popoverContent()
            }
            .task(id: isPresented) {
                guard isPresented else { return }

                do {
                    try await Task.sleep(for: autoDismissAfter)
                } catch {
                    return
                }

                if isPresented {
                    isPresented = false
                }
            }
    }
}

private struct TriggeredToastPopoverModifier<TriggerID: Equatable, PopoverContent: View>: ViewModifier {
    let triggerID: TriggerID?
    @State private var isPresented = false

    let autoDismissAfter: Duration
    let arrowEdge: Edge
    let onTrigger: () -> Void
    let popoverContent: () -> PopoverContent

    func body(content: Content) -> some View {
        content
            .toastPopover(
                isPresented: $isPresented,
                autoDismissAfter: autoDismissAfter,
                arrowEdge: arrowEdge,
                content: popoverContent
            )
            .task(id: triggerID) {
                guard triggerID != nil else { return }

                isPresented = true
                onTrigger()
            }
    }
}

// MARK: - Toast with Binding<Bool>
extension View {
    func toastPopover<PopoverContent: View>(
        isPresented: Binding<Bool>,
        autoDismissAfter: Duration = .seconds(1.6),
        arrowEdge: Edge = .top,
        @ViewBuilder content: @escaping () -> PopoverContent
    ) -> some View {
        modifier(
            ToastPopoverModifier(
                isPresented: isPresented,
                autoDismissAfter: autoDismissAfter,
                arrowEdge: arrowEdge,
                popoverContent: content
            )
        )
    }

    func toast(
        _ message: String,
        isPresented: Binding<Bool>,
        autoDismissAfter: Duration = .seconds(1.6),
        arrowEdge: Edge = .top
    ) -> some View {
        toastPopover(
            isPresented: isPresented,
            autoDismissAfter: autoDismissAfter,
            arrowEdge: arrowEdge
        ) {
            Text(message)
                .font(.font13)
                .foregroundStyle(Color.textPrimary)
                .padding(10)
        }
    }
}

// MARK: - Toast with TriggerID
extension View {
    func toastPopover<TriggerID: Equatable, PopoverContent: View>(
        triggerID: TriggerID?,
        autoDismissAfter: Duration = .seconds(1.6),
        arrowEdge: Edge = .top,
        onTrigger: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> PopoverContent
    ) -> some View {
        modifier(
            TriggeredToastPopoverModifier(
                triggerID: triggerID,
                autoDismissAfter: autoDismissAfter,
                arrowEdge: arrowEdge,
                onTrigger: onTrigger,
                popoverContent: content
            )
        )
    }

    func toast<TriggerID: Equatable>(
        _ message: String,
        triggerID: TriggerID?,
        autoDismissAfter: Duration = .seconds(1.6),
        arrowEdge: Edge = .top,
        onTrigger: @escaping () -> Void = {}
    ) -> some View {
        toastPopover(
            triggerID: triggerID,
            autoDismissAfter: autoDismissAfter,
            arrowEdge: arrowEdge,
            onTrigger: onTrigger
        ) {
            Text(message)
                .font(.font13)
                .foregroundStyle(Color.textPrimary)
                .padding(10)
        }
    }
}
