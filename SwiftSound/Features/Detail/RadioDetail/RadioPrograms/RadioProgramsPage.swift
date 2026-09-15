//
//  RadioProgramsPage.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/9/11.
//

import SwiftUI

struct RadioProgramsPage: View {
    @ObservedObject var viewModel: RadioProgramsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.paginationSpacing) {
            ProgramTable(
                programs: viewModel.programs,
                onSortChange: { ascending in
                    Task { await viewModel.updateSort(asc: ascending) }
                }
            )
            .loadable(state: viewModel.state)

            if viewModel.pageCount > 1 {
                PaginationControl(
                    currentPage: Binding(
                        get: { viewModel.currentPage },
                        set: { page in
                            Task { await viewModel.load(page: page) }
                        }
                    ),
                    pageCount: viewModel.pageCount,
                    isEnabled: !viewModel.state.isLoading
                )
                .frame(maxWidth: .infinity)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

private extension RadioProgramsPage {
    enum Layout {
        static let paginationSpacing: CGFloat = 6
    }
}

#Preview {
    RadioProgramsPage(viewModel: RadioProgramsViewModel(id: Radio.preview1.id))
}
