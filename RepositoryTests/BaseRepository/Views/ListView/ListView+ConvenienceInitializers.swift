import Foundation
import SwiftUI

/// Convenience ListView's initializers
extension ListView where LoadMoreView == EmptyView  {
    /// PaginatedListView's initializer
    /// - Parameters:
    ///   - viewModel: ViewModel to handle data flow
    ///   - emptyBooksLoadingView: View when list is empty and is loading (ProgressView or Skeleton)
    ///   - emptyErrorView: View when list is empty and error occured
    ///   - emptyLoadedView: View when list is loaded and have no data
    ///   - itemView: View of an Item on the list
    ///   - loadMoreView: View showing at the bottom of the list (ex: load more)
    init(
        viewModel: ViewModel,
        presentationStyle: ListViewPresentationStyle = .lazyVStack,
        @ViewBuilder emptyBooksLoadingView: @escaping () -> EmptyBooksLoadingView,
        @ViewBuilder emptyErrorView: @escaping (Error) -> EmptyErrorView,
        @ViewBuilder emptyLoadedView: @escaping () -> EmptyLoadedView,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) {
        self.init(
            viewModel: viewModel,
            presentationStyle: presentationStyle,
            emptyBooksLoadingView: emptyBooksLoadingView,
            emptyErrorView: emptyErrorView,
            emptyLoadedView: emptyLoadedView,
            contentView: contentView,
            loadMoreView: { _ in
                EmptyView()
            }
        )
    }
}
