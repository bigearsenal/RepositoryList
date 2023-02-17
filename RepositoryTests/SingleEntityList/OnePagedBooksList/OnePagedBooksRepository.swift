//
//  OnePagedBooksRepository.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import Foundation

final class OnePagedBooksRepository: AnyListRepository {
    func shouldFetch() -> Bool {
        true
    }
    
    func fetch() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 3_000_000_000)
        return Array(0..<10).map { Book(name: "Book#\($0)") }
    }
}
