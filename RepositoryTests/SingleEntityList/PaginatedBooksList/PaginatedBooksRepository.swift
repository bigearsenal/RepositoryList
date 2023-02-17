//
//  PaginatedBooksRepository.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import Foundation

final class PaginatedBooksListRepository: AnyPaginatedListRepository {
//    let maxPage = 10
    let limit = 20
    let paginationStrategy: LimitOffsetPaginationStrategy
    
    init() {
        paginationStrategy = LimitOffsetPaginationStrategy(limit: limit)
    }
    
    func fetch() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return await Array(paginationStrategy.offset..<paginationStrategy.offset+paginationStrategy.limit).map { Book(name: "Book#\($0)") }
    }
}
