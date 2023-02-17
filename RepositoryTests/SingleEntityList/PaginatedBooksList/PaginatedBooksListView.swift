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
        List {
            switch viewModel.state {
            case .initialized, .loading where viewModel.data.isEmpty:
                ProgressView()
            case .error:
                Text("Error")
            default:
                ForEach(viewModel.data) { book in
                    Text(book.name)
                }
            }
            if self.viewModel.repository.shouldFetch() {
                Text("Fetching more...")
                    .task {
                        try? await viewModel.fetchNext()
                    }
            }
            
        }
        .task {
            try? await viewModel.reload()
        }
        .refreshable {
            try? await viewModel.refresh()
        }
    }
}

struct PaginatedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        PaginatedBooksListView()
    }
}
