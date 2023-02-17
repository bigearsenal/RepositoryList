//
//  SectionedBooksList.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import SwiftUI

struct SectionedBooksListView: View {
    @State var sections: [BooksListSection] = []
    @StateObject var viewModel = PaginatedListViewModel(
        repository: PaginatedBooksListRepository()
    )
    
    var body: some View {
        List {
            ForEach(sections, id: \.id) {section in
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
                }
            }
            
            if viewModel.repository.shouldFetch() {
                if viewModel.data.isEmpty == false {
                    Text("Fetching more...")
                        .task {
                            try? await viewModel.fetchNext()
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
            try? await viewModel.reload()
        }
        .refreshable {
            try? await viewModel.refresh()
        }
        .onReceive(viewModel.sectionsPublisher) { sections in
            self.sections = sections as! [BooksListSection]
        }
    }
}

struct SectionedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        SectionedBooksListView()
    }
}
