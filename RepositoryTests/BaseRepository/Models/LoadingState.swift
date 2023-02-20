import Foundation

/// Loading state for a specific time-consuming operation
enum LoadingState {
    /// Nothing loaded
    case initialized
    /// Data is loading
    case loading
    /// Data is loaded
    case loaded
    /// Error
    case error
}

enum ListLoadingState {
    enum Status {
        case loading
        case loaded
        case error(Error)
    }
    enum LoadMoreStatus {
        case loading
        case reachedEndOfList
        case error(Error)
    }
    case empty(Status)
    case nonEmpty(loadMoreStatus: LoadMoreStatus)
}
