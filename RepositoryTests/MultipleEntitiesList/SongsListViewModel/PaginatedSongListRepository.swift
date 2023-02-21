import Foundation

final class PaginatedSongsListRepository: AnyPaginatedListRepository {
    // MARK: - Properties

    let paginationStrategy: LimitOffsetPaginationStrategy
    let api = MockPaginatedSongsAPI()
    @MainActor var currentPage: Int { api.currentPage }
    
    // MARK: - Initializer

    init(limit: Int = 20) {
        paginationStrategy = LimitOffsetPaginationStrategy(limit: limit)
    }
    
    // MARK: - AnyPaginatedListRepository
    func fetch() async throws -> [Song] {
        try await api.getSongs(offset: paginationStrategy.offset, limit: paginationStrategy.limit)
    }
}
