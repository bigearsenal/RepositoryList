//
//  OnePageBooksAPI.swift
//  RepositoryTests
//
//  Created by Chung Tran on 19/02/2023.
//

import Foundation

// MARK: - One paged api
enum BooksAPIError: Swift.Error {
    case fakeError
}

final class MockOnePagedBooksAPI {
    func getAllBooks() async throws -> [Book] {
        print("BooksAPI: fetching all books")
        try await Task.sleep(nanoseconds: 500_000_000)
        // fake error in 1/3 case
        guard Int.random(in: 0..<3) > 0 else { throw BooksAPIError.fakeError }
        // fake empty state in 1/3 case
        guard Int.random(in: 0..<3) > 0 else { return [] }
        // no error, no empty
        let result = Array(0..<10).map { Book(name: "Book#\($0)") }
        print("BooksAPI: fetched \(result.count) results")
        return result
    }
}

// MARK: - Pagination api

final class MockPaginatedBooksAPI {
    
    
    let maxPage = 5
    @MainActor var currentPage = 1
    
    func getBooks(offset: Int, limit: Int) async throws -> [Book] {
        print("BooksAPI: fetching..., limit: \(limit), offset: \(offset)")
        
        // fake api delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // fake error in 1/3 case
        guard Int.random(in: 0..<3) > 0 else { throw BooksAPIError.fakeError }
        
        let page = offset / limit + 1
        let numberOfRecords: Int = page >= maxPage ? .random(in: 0..<limit) : limit // return less than limit to end the list
        
        await MainActor.run {
            currentPage = page
        }
        let result = Array(offset..<offset+numberOfRecords).map { Book(name: "Book#\($0)") }
        print("BooksAPI: fetched \(result.count) results, limit: \(limit), offset: \(offset)")
        return result
    }
}
