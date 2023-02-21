import Foundation

enum SongsAPIError: Swift.Error {
    case fakeError
}

final class MockPaginatedSongsAPI {
    
    
    let maxPage = 5
    @MainActor var currentPage = 1
    
    func getSongs(offset: Int, limit: Int) async throws -> [Song] {
        print("BooksAPI: fetching..., limit: \(limit), offset: \(offset)")
        
        // fake api delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // fake error in 1/3 case
        guard Int.random(in: 0..<3) > 0 else { throw SongsAPIError.fakeError }
        
        let page = offset / limit + 1
        let numberOfRecords: Int = page >= maxPage ? .random(in: 0..<limit) : limit // return less than limit to end the list
        
        await MainActor.run {
            currentPage = page
        }
        let result = Array(offset..<offset+numberOfRecords).map { Song(name: "Song#\($0)", systemImage: "\($0).circle") }
        print("SongsAPI: fetched \(result.count) results, limit: \(limit), offset: \(offset)")
        return result
    }
}
