//
//  SectionedBooksList.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import SwiftUI

struct SectionedBooksListView: View {
    
    @StateObject var viewModel = SectionedBooksListViewModel(
        repository: PaginatedBooksListRepository()
    )
    
    var body: some View {
        ListView(
            viewModel: viewModel,
            presentationStyle: .list,
            emptyBooksLoadingView: {
                // Skeleton may appear here
                List {
                    BooksLoadingView()
                }
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
            contentView: {
                ForEach(viewModel.sections, id: \.id) {section in
                    Section(header: Text(section.name)) {
                        ForEach(section.items) { book in
                            BookView(book: book)
                        }
                    }
                }
            },
            loadMoreView: { status in
                LoadMoreView(loadMoreStatus: status) {
                    await viewModel.fetchNext()
                }
            }
        )
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    if viewModel.error != nil {
                        Text("Error!")
                            .foregroundColor(.red)
                    }
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

struct SectionedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        SectionedBooksListView()
    }
}
