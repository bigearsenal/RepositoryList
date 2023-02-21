import Foundation

@MainActor
final class BooksSongsCollectionViewModel: ObservableObject {
    // MARK: - Properties

    let booksViewModel = SectionedBooksListViewModel(repository: PaginatedBooksListRepository())
    let songsViewModel = SectionedSongsListViewModel(repository: PaginatedSongsListRepository())
    
    // MARK: - Initializers
    
    
}
