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
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .error:
                Text("Error")
            default:
                ForEach(viewModel.data) { book in
                    Text(book.name)
                }
            }
            
            if viewModel.repository.shouldFetch() {
                if viewModel.data.isEmpty == false {
                    Text("Fetching more...")
                        .task {
                            await viewModel.fetchNext()
                        }
                }
            } else {
                Text("End of list")
            }
        }
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Page: \(viewModel.repository.currentPage)")
                }
            }.padding()
        )
        .task {
            await viewModel.reload()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

struct PaginatedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        PaginatedBooksListView()
    }
}
