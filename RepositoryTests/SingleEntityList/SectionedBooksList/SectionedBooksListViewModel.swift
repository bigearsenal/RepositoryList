//
//  SectionedBooksListViewModel.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import Foundation
import Combine

// Create section type
struct BooksListSection: ListSection {
    var id: String
    var items: [Book]
    var loadingState: LoadingState
    var error: String?
    
    var name: String {
        "Page \(id)"
    }
}

// Create view model

final class SectionedBooksListViewModel: PaginatedListViewModel<PaginatedBooksListRepository> {}

// Conform to SectionsConvertibleListViewModel
extension SectionedBooksListViewModel: SectionsConvertibleListViewModel {
    var sections: [BooksListSection] {
        let chunkedData = data
            .chunked(into: 20)
            .enumerated()
        
        print(chunkedData)
        
        return chunkedData
            .map { [weak self] index, items in
                BooksListSection(
                    id: "\(index + 1)",
                    items: items,
                    loadingState: .loaded,
                    error: self?.error?.localizedDescription
                )
            }
    }
}

// Create ViewModel

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
