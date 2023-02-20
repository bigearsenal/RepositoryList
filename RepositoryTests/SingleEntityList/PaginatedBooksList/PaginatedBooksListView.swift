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
        PaginatedListView(
            viewModel: viewModel,
            emptyLoadingView: {
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
                VStack(spacing: 20) {
                    Image(systemName: "binoculars")
                        .font(.largeTitle)
                    
                    Text("Nothing found")
                    
                    Button("Retry") {
                        Task {
                            await viewModel.reload()
                        }
                    }
                }
            },
            itemView: { book in
                Text(book.name)
            },
            nonEmptyLoadingView: {
                Text("Fetching more...")
                    .task {
                        await viewModel.fetchNext()
                    }
            },
            nonEmptyErrorView: { _ in
                Button("Error fetching more item... Tap to try again") {
                    Task {
                        await viewModel.fetchNext()
                    }
                }
            },
            endOfListView: {
                Text("End of list")
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
