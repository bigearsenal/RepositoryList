# RepositoryList

## How to create SingleEntity List

Single entity list is a list that contains data of only 1 entity

https://user-images.githubusercontent.com/6975538/219600688-317f91d6-cf8a-4f8d-8e21-2d1100662c07.mov

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
        try await bookAPI.getBooksList()
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

### Create `ListViewModel<Repository>`

Use created `Repository` to initialize `ListViewModel` (or override ListViewModel if needed).

```swift
// One page
@StateObject var viewModel = ListViewModel(
    repository: OnePagedBooksRepository()
)

// Pagination
@StateObject var viewModel = PaginatedListViewModel(
    repository: PaginatedBooksListRepository()
)
```

### Use `ListViewModel` in SwiftUI

Example: For non-pagination list:

```swift
struct OnePagedBooksListView: View {
    @StateObject var viewModel = ListViewModel(
        repository: OnePagedBooksRepository()
    )
    
    var body: some View {
        List {
            switch viewModel.state {
            case .initialized, .loading where viewModel.data.isEmpty:
                ProgressView()
            case .error:
                Text("Error")
            default:
                ForEach(viewModel.data) { book in
                    Text(book.name)
                }
            }
            
        }
        .task {
            try? await viewModel.reload()
        }
        .refreshable {
            try? await viewModel.refresh()
        }
    }
}
```

Example: For paginated list with infinite scrolling

```swift
struct PaginatedBooksListView: View {
    @StateObject var viewModel = PaginatedListViewModel(
        repository: PaginatedBooksListRepository()
    )
    
    var body: some View {
        List {
            // Show list base on loadingState
            switch viewModel.state {
            case .initialized, .loading where viewModel.data.isEmpty:
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .error:
                Text("Error")
            default:
                ForEach(viewModel.data) { book in
                    Text(book.name)
                }
            }
            
            // Load more indicator
            if viewModel.repository.shouldFetch() {
                if viewModel.data.isEmpty == false {
                    Text("Fetching more...")
                        .task {
                            try? await viewModel.fetchNext()
                        }
                }
            } else {
                Text("End of list")
            }
        }
        // Reload viewModel onAppear
        .task {
            try? await viewModel.reload()
        }
        // Refresh data when pull-to-refresh
        .refreshable {
            try? await viewModel.refresh()
        }
    }
}
```

For `SectionedBooksListView`, make Our viewModel conform to `SectionsConvertibleListViewModel`:

```swift
class BooksPaginatedListViewModel: PaginatedListViewModel<PaginatedBooksListRepository> {
    ...
}

extension BooksPaginatedListViewModel: SectionsConvertibleListViewModel {
    var sectionsPublisher: AnyPublisher<[any ListSection], Never> {
        $data
            .map { items in
                // Indicate how data is mapped to Section
                ...
            }
            .eraseToAnyPublisher()
    }
}
```

Use it in SwiftUI

```swift
struct SectionedBooksListView: View {
    @State var sections: [BooksListSection] = []
    @StateObject var viewModel = PaginatedListViewModel(
        repository: PaginatedBooksListRepository()
    )
    
    var body: some View {
        List {
            ForEach(sections, id: \.id) {section in
                Section(header: Text(section.name)) {
                    switch section.loadingState {
                    case .initialized, .loading where section.items.isEmpty:
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .error:
                        Text("Error")
                    default:
                        ForEach(section.items) { book in
                            Text(book.name)
                        }
                    }
                }
            }
            
            if viewModel.repository.shouldFetch() {
                if viewModel.data.isEmpty == false {
                    Text("Fetching more...")
                        .task {
                            try? await viewModel.fetchNext()
                        }
                }
            } else {
                Text("End of list")
            }
        }
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Page: \(viewModel.repository.currentPage)")
                }
            }.padding()
        )
        .task {
            try? await viewModel.reload()
        }
        .refreshable {
            try? await viewModel.refresh()
        }
        // Bind sectionsPublisher to sections
        .onReceive(viewModel.sectionsPublisher) { sections in
            self.sections = sections as! [BooksListSection]
        }
    }
}
```

## How to create MultipleEntities List

Multiple entities list is a list that contains data of more than 1 entity

To be implemented...

## Demo

Open applcation or Review to find out more
