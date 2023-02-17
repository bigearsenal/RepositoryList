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
    var id: Int
    var items: [Book]
}

// Make ListViewModel conform to SectionsConvertibleListViewModel
extension PaginatedListViewModel<PaginatedBooksListRepository>: SectionsConvertibleListViewModel {
    var sectionsPublisher: AnyPublisher<[any ListSection], Never> {
        $data
            .map { items in
                let chunkedArray = items.chunked(into: 10)
                return chunkedArray.enumerated()
                    .map { index, items in
                        BooksListSection(id: index, items: items)
                    }
            }
            .eraseToAnyPublisher()
    }
}

// Create ViewModel

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
