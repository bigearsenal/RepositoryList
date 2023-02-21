//
//  MultipleEntitiesListView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import SwiftUI
import SkeletonUI

struct MultipleEntitiesListView: View {
    @StateObject var booksViewModel = SectionedBooksListViewModel(
        repository: PaginatedBooksListRepository(limit: 5)
    )
    @StateObject var songsViewModel = SectionedSongsListViewModel(
        repository: PaginatedSongsListRepository(limit: 5)
    )
    
    var body: some View {
        List {
            // Books
            books
            
            // Songs
            songs
        }
        .task {
            await booksViewModel.reload()
        }
        .task {
            await songsViewModel.reload()
        }
        .refreshable {
            Task {
                await songsViewModel.reload()
            }
            await booksViewModel.refresh()
        }
    }
    
    // MARK: - View Builders

    var books: some View {
        Group {
            switch booksViewModel.state {
            case .empty(let status):
                emptyBooks(status: status)
            case .nonEmpty(let loadMoreStatus):
                nonEmptyBooks(loadMoreStatus: loadMoreStatus)
            }
        }
    }
    
    var songs: some View {
        Section(header: Text("Songs")) {
            switch songsViewModel.state {
            case .empty(let status):
                emptySongs(status: status)
            case .nonEmpty(let loadMoreStatus):
                nonEmptySongs(loadMoreStatus: loadMoreStatus)
            }
        }
    }
    
    // MARK: - Helpers

    func emptyBooks(status: ListLoadingState.Status) -> some View {
        Section(header: Text("Books")) {
            EmptyBooksListGroup(status: status) {
                await booksViewModel.reload()
            }
        }
    }
    
    func nonEmptyBooks(loadMoreStatus: ListLoadingState.LoadMoreStatus) -> some View {
        Group {
            ForEach(booksViewModel.sections, id: \.id) {section in
                Section(header: Text("Books " + section.name)) {
                    ForEach(section.items) { book in
                        BookView(book: book)
                    }
                }
            }
            Section {
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
    
    func emptySongs(status: ListLoadingState.Status) -> some View {
        EmptySongsListGroup(status: status) {
            await songsViewModel.reload()
        }
    }
    
    func nonEmptySongs(loadMoreStatus: ListLoadingState.LoadMoreStatus) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(songsViewModel.sections, id: \.id) {section in
                    ForEach(section.items) { song in
                        SongView(song: song)
                    }
                }
                
                switch loadMoreStatus {
                case .loading:
                    SongsLoadingView()
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

struct MultipleEntitiesListView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleEntitiesListView()
    }
}
