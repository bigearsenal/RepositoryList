# RepositoryList

## How to create SingleEntity List

Single entity list is a list that contains data of only 1 entity

### Create Model

Create a list item model that conform to `Hashable & Identifiable`

```swift
struct Book: Hashable & Identifiable {
    var id: String { name }
    let name: String
}
```

### Create Repository

Create a suitable `Repository` to handle fetching data. Depend on how you present data, use can choose the `Repository` protocol that suits your need:
- `AnyListRepository`: Base repository type that handle list in general.
- `AnyPaginatedListRepository`: Repository that can handle paginated list. It requires a `PaginationStrategy` to define how to manage pagination (for example: when to stop fetching as list is ended).

Example: `AnyListRepository` for one-page only list

```swift
final class OnePagedBooksRepository: AnyListRepository {
    func fetch() async throws -> [Book] {
        // try await bookAPI.getBooksList()
        
        // mock
        try await Task.sleep(nanoseconds: 500_000_000)
        return Array(0..<10).map { Book(name: "Book#\($0)") }
    }
}
```

Example: `AnyPaginatedListRepository` for paginated list

```swift
final class PaginatedBooksListRepository: AnyPaginatedListRepository {
    /// Pagination using limit and offset, the list end when last snapshot.count < limit
    let paginationStrategy = LimitOffsetPaginationStrategy(limit: limit)
    
    func fetch() async throws -> [Book] {
        try await bookAPI.getBooksList(limit: paginationStrategy.limit, offset: paginationStrategy.offset)
    }
}
```

If the data require section, conform it to `SectionsConvertibleListViewModel`

```swift
class MyListViewModel: 

extension PaginatedListViewModel<PaginatedBooksListRepository>: SectionsConvertibleListViewModel {
    var sectionsPublisher: AnyPublisher<[any ListSection], Never> {
        $data
            .map { items in
                let chunkedArray = items.chunked(into: 10)
                return chunkedArray.enumerated()
                    .map { [weak self] index, items in
                        BooksListSection(
                            id: "\(index + 1)",
                            items: items,
                            loadingState: self?.state ?? .loaded,
                            error: self?.error?.localizedDescription
                        )
                    }
            }
            .eraseToAnyPublisher()
    }
}
```
