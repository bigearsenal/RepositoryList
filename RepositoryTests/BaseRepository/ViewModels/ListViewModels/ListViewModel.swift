import Foundation
import Combine

/// Reusable ViewModel to manage a List of some Kind of item
@MainActor
class ListViewModel<Repository: AnyListRepository>: ObservableObject {
    
    // MARK: - Associated types
    
    /// Type of the item
    typealias ItemType = Repository.ItemType
    
    // MARK: - Public properties
    
    /// Repository that is responsible for fetching data
    let repository: Repository
    
    /// Current running task
    var loadingTask: Task<[ItemType], Error>?
    
    /// The current data
    @Published var data: [ItemType] = []

    /// The current loading state of the data
    @Published var isLoading = false

    /// Optional error if occurred
    @Published var error: Error?
    
    // MARK: - Initializer
    
    /// ItemViewModel's initializer
    /// - Parameters:
    ///   - initialData: initial data for begining state of the Repository
    ///   - repository: repository to handle data fetching
    init(
        initialData: [ItemType] = [],
        repository: Repository
    ) {
        self.repository = repository
        
        // feed data with initial data
        if !initialData.isEmpty {
            handleNewData(initialData)
        }
    }

    // MARK: - Actions

    /// Erase data and reset repository to its initial state
    func flush() {
        data = []
        isLoading = false
        error = nil
    }
    
    /// Erase and reload all data
    func reload() async {
        flush()
        await request()
    }
    
    /// Refresh data without erasing current data
    func refresh() async {
        await request()
    }
    
    /// Request data from outside to get new data
    /// - Returns: New data
    @discardableResult
    func request() async -> Result<[ItemType], Error> {
        // prevent unwanted request
        guard repository.shouldFetch() else {
            return .failure(CancellationError())
        }
        
        // cancel previous request
        loadingTask?.cancel()
        
        // mark as loading
        isLoading = true
        error = nil
        
        // assign and execute loadingTask
        loadingTask = Task { [unowned self] in
            try await repository.fetch()
        }
        
        // await value
        do {
            let newData = try await loadingTask!.value
            handleNewData(newData)
            return .success(newData)
        } catch {
            // ignore cancellation error
            if !(error is CancellationError) {
                handleError(error)
            }
            return .failure(error)
        }
    }
    
    /// Handle new data that just received
    /// - Parameter newData: the new data received
    func handleNewData(_ newData: [ItemType]) {
        data = newData
        error = nil
        isLoading = false
    }
    
    /// Handle error when received
    /// - Parameter err: the error received
    func handleError(_ err: Error) {
        error = err
        isLoading = false
    }
    
    // MARK: - Getter
    
    /// List loading state
    var state: ListLoadingState {
        // Empty state
        if data.isEmpty {
            let status: ListLoadingState.Status
            
            // empty loading
            if isLoading {
                status = .loading
            }
            
            // empty error
            else if let error {
                status = .error(error)
            }
            
            // empty
            else {
                status = .loaded
            }
            return .empty(status)
        }
        
        // Non-empty state
        else {
            return .nonEmpty(loadMoreStatus: .reachedEndOfList)
        }
    }
    
//    /// Override data
//    func overrideData(by newData: [ItemType]) {
//        guard state == .loaded else { return }
//        handleNewData(newData)
//    }

//    /// Update multiple records with a closure
//    /// - Parameter closure: updating closure
//    func batchUpdate(closure: ([ItemType]) -> [ItemType]) {
//        let newData = closure(data)
//        overrideData(by: newData)
//    }
//
//    /// Update item that matchs predicate
//    /// - Parameters:
//    ///   - predicate: predicate to find item
//    ///   - transform: transform item before udpate
//    /// - Returns: true if updated, false if not
//    @discardableResult
//    func updateItem(where predicate: (ItemType) -> Bool, transform: (ItemType) -> ItemType?) -> Bool {
//        // modify items
//        var itemsChanged = false
//        if let index = data.firstIndex(where: predicate),
//           let item = transform(data[index]),
//           item != data[index]
//        {
//            itemsChanged = true
//            var data = self.data
//            data[index] = item
//            overrideData(by: data)
//        }
//
//        return itemsChanged
//    }
//
//    /// Insert item into list or update if needed
//    /// - Parameters:
//    ///   - item: item to be inserted
//    ///   - predicate: predicate to find item
//    ///   - shouldUpdate: should update instead
//    /// - Returns: true if inserted, false if not
//    @discardableResult
//    func insert(_ item: ItemType, where predicate: ((ItemType) -> Bool)? = nil, shouldUpdate: Bool = false) -> Bool
//    {
//        var items = data
//
//        // update mode
//        if let predicate = predicate {
//            if let index = items.firstIndex(where: predicate), shouldUpdate {
//                items[index] = item
//                overrideData(by: items)
//                return true
//            }
//        }
//
//        // insert mode
//        else {
//            items.append(item)
//            overrideData(by: items)
//            return true
//        }
//
//        return false
//    }
//
//    /// Remove item that matches a predicate from list
//    /// - Parameter predicate: predicate to find item
//    /// - Returns: removed item
//    @discardableResult
//    func removeItem(where predicate: (ItemType) -> Bool) -> ItemType? {
//        var result: ItemType?
//        var data = self.data
//        if let index = data.firstIndex(where: predicate) {
//            result = data.remove(at: index)
//        }
//        if result != nil {
//            overrideData(by: data)
//        }
//        return nil
//    }
}
