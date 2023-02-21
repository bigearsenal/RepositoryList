//
//  PaginatedBooksRepository.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import Foundation

final class PaginatedBooksListRepository: AnyPaginatedListRepository {
    // MARK: - Properties

    let paginationStrategy: LimitOffsetPaginationStrategy
    let api = MockPaginatedBooksAPI()
    @MainActor var currentPage: Int { api.currentPage }
    
    // MARK: - Initializer

    init(limit: Int = 20) {
        paginationStrategy = LimitOffsetPaginationStrategy(limit: limit)
    }
    
    // MARK: - AnyPaginatedListRepository
    func fetch() async throws -> [Book] {
        try await api.getBooks(offset: paginationStrategy.offset, limit: paginationStrategy.limit)
    }
}
