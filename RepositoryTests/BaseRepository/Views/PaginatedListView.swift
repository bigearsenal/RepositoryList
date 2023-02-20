import Foundation
import SwiftUI

/// Reusable list view with paginated behavior
struct PaginatedListView<
    Repository: AnyPaginatedListRepository,
    ViewModel: PaginatedListViewModel<Repository>,
    EmptyLoadingView: View,
    EmptyErrorView: View,
    EmptyLoadedView: View,
    ItemView: View,
    NonEmptyLoadingView: View,
    NonEmptyErrorView: View,
    EndOfListView: View
>: View {
    // MARK: - Properties
    
    /// ViewModel that handle data flow
    @ObservedObject var viewModel: ViewModel
    
    /// Type of list
    let presentationStyle: ListViewPresentationStyle
    
    /// View to handle state when list is empty and is loading, for example ProgressView or Skeleton
    var emptyLoadingView: () -> EmptyLoadingView
    
    /// View to handle state when list is empty and error occurred at the first time loading
    var emptyErrorView: (Error) -> EmptyErrorView
    
    /// View to handle state when list is loaded and have no data
    var emptyLoadedView: () -> EmptyLoadedView
    
    /// View of an item of the list
    var itemView: (Repository.ItemType) -> ItemView
    
    /// View to handle state when list is loading more item
    var nonEmptyLoadingView: () -> NonEmptyLoadingView
    
    /// View to handle state when load more has error and is not empty
    var nonEmptyErrorView: (Error) -> NonEmptyErrorView
    
    /// View to handle state when list is ended, no more data to load
    var endOfListView: () -> EndOfListView
    
    // MARK: - Initializer
    
    /// PaginatedListView's initializer
    /// - Parameters:
    ///   - viewModel: ViewModel to handle data flow
    ///   - presentationStyle: Presenation type of the list   
    ///   - emptyLoadingView: View when list is empty and is loading (ProgressView or Skeleton)
    ///   - emptyErrorView: View when list is empty and error occured
    ///   - emptyLoadedView: View when list is loaded and have no data
    ///   - itemView: View of an Item on the list
    ///   - nonEmptyLoadingView: View when list is loading more item (show at the end of the list)
    ///   - nonEmptyErrorView: View when load more has error (show at the end of the list)
    ///   - endOfListView: View to indicate if no more data to load (show at the end of the list)
    init(
        viewModel: ViewModel,
        presentationStyle: ListViewPresentationStyle = .lazyVStack,
        @ViewBuilder emptyLoadingView: @escaping () -> EmptyLoadingView,
        @ViewBuilder emptyErrorView: @escaping (Error) -> EmptyErrorView,
        @ViewBuilder emptyLoadedView: @escaping () -> EmptyLoadedView,
        @ViewBuilder itemView: @escaping (Repository.ItemType) -> ItemView,
        @ViewBuilder nonEmptyLoadingView: @escaping () -> NonEmptyLoadingView,
        @ViewBuilder nonEmptyErrorView: @escaping (Error) -> NonEmptyErrorView,
        @ViewBuilder endOfListView: @escaping () -> EndOfListView
    ) {
        self.viewModel = viewModel
        self.presentationStyle = presentationStyle
        self.emptyLoadingView = emptyLoadingView
        self.emptyErrorView = emptyErrorView
        self.emptyLoadedView = emptyLoadedView
        self.itemView = itemView
        self.nonEmptyLoadingView = nonEmptyLoadingView
        self.nonEmptyErrorView = nonEmptyErrorView
        self.endOfListView = endOfListView
    }
    
    var body: some View {
        ListView(
            viewModel: viewModel,
            presentationStyle: presentationStyle,
            emptyLoadingView: emptyLoadingView,
            emptyErrorView: emptyErrorView,
            emptyLoadedView: emptyLoadedView,
            itemView: itemView,
            footerView: {
                switch viewModel.state {
                case let .nonEmpty(status, isEndOfList):
                    switch status {
                    case .error(let error):
                        nonEmptyErrorView(error)
                    case .loaded where isEndOfList == true:
                        endOfListView()
                    default:
                        nonEmptyLoadingView()
                    }
                default:
                    EmptyView()
                }
            }
        )
    }
}
