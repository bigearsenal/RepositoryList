//
//  MultipleEntitiesListView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import SwiftUI

struct MultipleEntitiesListView: View {
    @StateObject var booksViewModel = SectionedBooksListViewModel(repository: PaginatedBooksListRepository(limit: 5))
    @StateObject var songsViewModel = SectionedSongsListViewModel(repository: PaginatedSongsListRepository())
    
    var body: some View {
        List {
            // Books
            books
            
            // Songs
            songs
        }
        .refreshable {
            await(
                booksViewModel.reload(),
                songsViewModel.reload()
            )
        }
    }
    
    // MARK: - Books

    var books: some View {
        Group {
            switch booksViewModel.state {
            case .empty(let status):
                Section(header: Text("Books")) {
                    EmptyListGroup(status: status) {
                        await booksViewModel.reload()
                    }
                }
                    .task {
                        await booksViewModel.reload()
                    }
            case .nonEmpty(let loadMoreStatus):
                ForEach(booksViewModel.sections, id: \.id) {section in
                    Section(header: Text("Books " + section.name)) {
                        ForEach(section.items) { book in
                            Text(book.name)
                        }
                        switch loadMoreStatus {
                        case .loading:
                            Button("Fetch more") {
                                Task {
                                    await booksViewModel.fetchNext()
                                }
                            }
                                
                        case .reachedEndOfList:
                            EmptyView()
                        case .error:
                            Button("Error fetching more item... Tap to try again") {
                                Task {
                                    await booksViewModel.fetchNext()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    var songs: some View {
        Group {
            switch songsViewModel.state {
            case .empty(let status):
                EmptyListGroup(status: status) {
                    await songsViewModel.reload()
                }
                .task {
                    await songsViewModel.reload()
                }
                .frame(height: 200)
            case .nonEmpty(let loadMoreStatus):
                Section(header: Text("Songs")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(songsViewModel.sections, id: \.id) {section in
                                ForEach(section.items) { song in
                                    SongView(song: song)
                                }
                            }
                            
                            switch loadMoreStatus {
                            case .loading:
                                LoadingView()
                                    .frame(width: 120, height: 120)
                                    .task {
                                        await songsViewModel.fetchNext()
                                    }
                            case .reachedEndOfList:
                                EmptyView()
                            case .error:
                                Text("Error")
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        Task {
                                            await songsViewModel.fetchNext()
                                        }
                                    }
                            }
                        }
                    }
                    .frame(height: 120)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            }
        }
    }
}

struct MultipleEntitiesListView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleEntitiesListView()
    }
}
