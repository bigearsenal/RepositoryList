import Foundation
import SwiftUI

/// Convenience ListView's initializers
extension ListView where FooterView == EmptyView {
    /// PaginatedListView's initializer
    /// - Parameters:
    ///   - viewModel: ViewModel to handle data flow
    ///   - emptyLoadingView: View when list is empty and is loading (ProgressView or Skeleton)
    ///   - emptyErrorView: View when list is empty and error occured
    ///   - emptyLoadedView: View when list is loaded and have no data
    ///   - itemView: View of an Item on the list
    ///   - footerView: View showing at the bottom of the list (ex: load more)
    init(
        viewModel: ViewModel,
        presentationStyle: ListViewPresentationStyle = .lazyVStack,
        @ViewBuilder emptyLoadingView: @escaping () -> EmptyLoadingView,
        @ViewBuilder emptyErrorView: @escaping (Error) -> EmptyErrorView,
        @ViewBuilder emptyLoadedView: @escaping () -> EmptyLoadedView,
        @ViewBuilder itemView: @escaping (Repository.ItemType) -> ItemView
    ) {
        self.init(
            viewModel: viewModel,
            presentationStyle: presentationStyle,
            emptyLoadingView: emptyLoadingView,
            emptyErrorView: emptyErrorView,
            emptyLoadedView: emptyLoadedView,
            itemView: itemView,
            footerView: {
                EmptyView()
            }
        )
    }
}
