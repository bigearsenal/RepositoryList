//
//  SectionedBooksListViewModel.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import Foundation
import Combine
// Create view model

final class SectionedBooksListViewModel: PaginatedListViewModel<PaginatedBooksListRepository> {}

// Conform to SectionsConvertibleListViewModel
extension SectionedBooksListViewModel: SectionsConvertibleListViewModel {
    var sections: [BooksListSection] {
        let chunkedData = data
            .chunked(into: 20)
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
