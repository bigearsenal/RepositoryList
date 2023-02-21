import Foundation

/// Reusable ViewModel to manage a paginated List of some Kind of item
@MainActor
class PaginatedListViewModel<Repository: AnyPaginatedListRepository>: ListViewModel<Repository> {
    // MARK: - Properties
    
    /// Result count of first request, can be use to keeps first record on refreshing
    private var firstPageCount: Int?
    
    // MARK: - Actions

    /// Erase data and reset repository to its initial state
    override func flush() {
        repository.paginationStrategy.resetPagination()
        super.flush()
    }

    /// Refresh data
    override func refresh() async {
        // keep first page as placeholder
        data = Array(data.prefix(firstPageCount ?? 0))
        isLoading = false
        error = nil
        
        // reset pagination
        repository.paginationStrategy.resetPagination()
        
        // request to update first page
        let firstPageResult = await request()
        switch firstPageResult {
        case .success(let firstPage):
            // replace first page
            data = firstPage
            isLoading = false
            error = nil
        case .failure(let failure):
            guard !(failure is CancellationError) else {
                return
            }
            data = []
            isLoading = false
            error = failure
        }
    }
    
    /// Request data from outside to get new data
    @discardableResult
    override func request() async -> Result<[ItemType], Error> {
        // request new data
        let result = await super.request()
        
        // catch result
        switch result {
        case .success(let newData):
            // assign first page count
            if firstPageCount == nil {
                firstPageCount = newData.count
            }
            
            // check if last page loaded
            repository.paginationStrategy.checkIfLastPageLoaded(lastSnapshot: newData)
            
            // move to next page
            repository.paginationStrategy.moveToNextPage()
        case .failure:
            // do nothing
            break
        }
        
        // return result
        return result
    }
    
    /// Handle new data that just received
    /// - Parameter newData: the new data received
    override func handleNewData(_ newData: [ItemType]) {
        // append data that is currently not existed in current data array
        data.append(contentsOf:
            newData.filter { newRecord in
                !data.contains { $0.id == newRecord.id }
            }
        )
        super.handleNewData(data)
    }

    /// Fetch next records if pagination is enabled
    func fetchNext() async {
        // call request
        await request()
    }
    
    /// List loading state
    override var state: ListLoadingState {
        let state = super.state
        
        switch state {
        case .nonEmpty:
            if repository.shouldFetch() {
                // Error at the end of the list
                if let error {
                    return .nonEmpty(loadMoreStatus: .error(error))
                }
                
                // Loading at the end of the list
                else {
                    return .nonEmpty(loadMoreStatus: .loading)
                }
            }
            else {
                return .nonEmpty(loadMoreStatus: .reachedEndOfList)
            }
        default:
            return state
        }
    }
    
//    func updateFirstPage(onSuccessFilterNewData: (([ItemType]) -> [ItemType])? = nil) {
//        let originalOffset = offset
//        offset = 0
//
//        task?.cancel()
//
//        task = Task {
//            let onSuccess = onSuccessFilterNewData ?? {[weak self] newData in
//                newData.filter {!(self?.data.contains($0) == true)}
//            }
//            var data = self.data
//            let newData = try await self.createRequest()
//            data = onSuccess(newData) + data
//            self.overrideData(by: data)
//        }
//
//        offset = originalOffset
//    }
}
