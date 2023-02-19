//
//  OnePageBooksAPI.swift
//  RepositoryTests
//
//  Created by Chung Tran on 19/02/2023.
//

import Foundation

// MARK: - One paged api

final class MockOnePagedBooksAPI {
    func getAllBooks() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Array(0..<10).map { Book(name: "Book#\($0)") }
    }
}

// MARK: - Pagination api

final class MockPaginatedBooksAPI {
    let maxPage = 5
    @MainActor var currentPage = 1
    
    func getBooks(offset: Int, limit: Int) async throws -> [Book] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let page = offset / limit + 1
        let numberOfRecords: Int = page >= maxPage ? .random(in: 0..<limit) : limit // return less than limit to end the list
        
        await MainActor.run {
            currentPage = page
        }
        return Array(offset..<offset+numberOfRecords).map { Book(name: "Book#\($0)") }
    }
}
