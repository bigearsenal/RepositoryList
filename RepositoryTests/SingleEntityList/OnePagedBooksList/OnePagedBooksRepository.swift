//
//  OnePagedBooksRepository.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import Foundation

final class OnePagedBooksRepository: AnyListRepository {
    let api = MockOnePagedBooksAPI()
    
    func fetch() async throws -> [Book] {
        try await api.getAllBooks()
    }
}
