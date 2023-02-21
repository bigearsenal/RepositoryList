//
//  SectionedBooksListViewModel.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import Foundation
import Combine
// Create view model

final class SectionedBooksListViewModel: PaginatedListViewModel<PaginatedBooksListRepository> {
    /// Refresh data
    override func refresh() async {
        let originalData = data
        await super.refresh()
        for (index, item) in data.enumerated() {
            if let orgIndex = originalData.firstIndex(where: {$0.id == item.id}) {
                data[index].refreshedCount = originalData[orgIndex].refreshedCount + 1
            }
        }
    }
}

// Conform to SectionsConvertibleListViewModel
extension SectionedBooksListViewModel: SectionsConvertibleListViewModel {
    var sections: [BooksListSection] {
        let chunkedData = data
            .chunked(into: 5)
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
