import Foundation

final class SectionedSongsListViewModel: PaginatedListViewModel<PaginatedSongsListRepository> {}

extension SectionedSongsListViewModel: SectionsConvertibleListViewModel {
    var sections: [SongsListSection] {
        let chunkedData = data
            .chunked(into: 4)
            .enumerated()
        
        return chunkedData
            .map { [weak self] index, items in
                .init(
                    id: "\(index + 1)",
                    items: items,
                    loadingState: .loaded,
                    error: self?.error?.localizedDescription
                )
            }
    }
}
