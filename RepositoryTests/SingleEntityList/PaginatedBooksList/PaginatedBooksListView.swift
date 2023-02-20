//
//  PaginatedBooksListView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import SwiftUI

struct PaginatedBooksListView: View {
    @StateObject var viewModel = PaginatedListViewModel(
        repository: PaginatedBooksListRepository()
    )
    
    var body: some View {
        ListView(
            viewModel: viewModel,
            presentationStyle: .list,
            emptyLoadingView: {
                // Skeleton may appear here
                LoadingView()
            },
            emptyErrorView: { _ in
                // Error like network error may appear here
                GeneralErrorView(reloadAction: {
                    Task {
                        await viewModel.reload()
                    }
                })
            },
            emptyLoadedView: {
                // Nothing found scene may appear here
                NothingFoundView {
                    Task {
                        await viewModel.reload()
                    }
                }
            },
            itemView: { _, book in
                BookView(book: book)
            },
            loadMoreView: { loadMoreStatus in
                switch loadMoreStatus {
                case .loading:
                    Text("Fetching more...")
                        .task {
                            await viewModel.fetchNext()
                        }
                case .reachedEndOfList:
                    Text("End of list")
                case .error:
                    Button("Error fetching more item... Tap to try again") {
                        Task {
                            await viewModel.fetchNext()
                        }
                    }
                }
            }
        )
            .overlay(
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Page: \(viewModel.repository.currentPage)")
                    }
                }.padding()
            )
    }
}

struct PaginatedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        PaginatedBooksListView()
    }
}
