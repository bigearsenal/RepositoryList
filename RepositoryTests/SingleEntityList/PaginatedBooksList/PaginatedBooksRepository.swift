//
//  PaginatedBooksRepository.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import Foundation

final class PaginatedBooksListRepository: AnyPaginatedListRepository {
    let maxPage = 5
    let limit = 20
    let paginationStrategy: LimitOffsetPaginationStrategy
    
    @MainActor var currentPage = 0
    
    init() {
        paginationStrategy = LimitOffsetPaginationStrategy(limit: limit)
    }
    
    func fetch() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let offset = await paginationStrategy.offset
        let page = offset / limit + 1
        let numberOfRecords: Int = page >= maxPage ? .random(in: 0..<limit) : limit // return less than limit to end the list
        
        await MainActor.run {
            currentPage = page
        }
        return Array(offset..<offset+numberOfRecords).map { Book(name: "Book#\($0)") }
    }
}
