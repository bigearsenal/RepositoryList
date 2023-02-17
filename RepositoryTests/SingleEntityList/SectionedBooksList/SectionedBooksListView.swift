//
//  SectionedBooksList.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import SwiftUI

struct SectionedBooksListView: View {
    @StateObject var viewModel = SectionedListViewModel(
        listViewModels: [
            PaginatedListViewModel(
                repository: PaginatedBooksListRepository()
            )
        ]
    )
    
    var body: some View {
        List {
            ForEach(viewModel.sections, id: \.id) {section in
                switch section {
                case let section as BooksListSection:
                    Section(header: Text(section.name)) {
                        switch section.loadingState {
                        case .initialized, .loading where section.items.isEmpty:
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        case .error:
                            Text("Error")
                        default:
                            ForEach(section.items) { book in
                                Text(book.name)
                            }
                        }

//                        if viewModel.repository.shouldFetch() {
//                            if viewModel.data.isEmpty == false {
//                                Text("Fetching more...")
//                                    .task {
//                                        try? await viewModel.fetchNext()
//                                    }
//                            }
//                        } else {
//                            Text("End of list")
//                        }
                    }
                default:
                    EmptyView()
                }
                
            }
            

        }
//        .overlay(
//            HStack {
//                Spacer()
//                VStack {
//                    Spacer()
//                    Text("Page: \(viewModel.repository.currentPage)")
//                }
//            }.padding()
//        )
        .task {
            try? await viewModel.reload()
        }
        .refreshable {
            try? await viewModel.refresh()
        }
    }
}

struct SectionedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        SectionedBooksListView()
    }
}
