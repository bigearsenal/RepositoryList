//
//  OnePagedBooksRepository.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import Foundation

final class OnePagedBooksRepository: AnyListRepository {
    func fetch() async throws -> [Book] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Array(0..<10).map { Book(name: "Book#\($0)") }
    }
}
