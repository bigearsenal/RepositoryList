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
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
            },
            emptyErrorView: { _ in
                // Error like network error may appear here
                VStack(spacing: 20) {
                    Image(systemName: "wrongwaysign")
                        .font(.largeTitle)
                    
                    Text("Something went wrong")
                    
                    Button("Retry") {
                        Task {
                            await viewModel.reload()
                        }
                    }
                }
            },
            emptyLoadedView: {
                // Nothing found scene may appear here
                VStack(spacing: 20) {
                    Image(systemName: "binoculars")
                        .font(.largeTitle)
                    
                    Text("Nothing found")
                    
                    Button("Reload") {
                        Task {
                            await viewModel.reload()
                        }
                    }
                }
            },
            itemView: { book in
                Text(book.name)
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
