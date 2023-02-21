import Foundation
import SwiftUI

/// Reusable list view
struct ListView<
    Repository: AnyListRepository,
    ViewModel: ListViewModel<Repository>,
    EmptyBooksLoadingView: View,
    EmptyErrorView: View,
    EmptyLoadedView: View,
    ContentView: View,
    LoadMoreView: View
>: View {
    // MARK: - Properties
    
    /// ViewModel that handle data flow
    @ObservedObject var viewModel: ViewModel
    
    /// Type of list
    let presentationStyle: ListViewPresentationStyle
    
    /// View to handle state when list is empty and is loading, for example ProgressView or Skeleton
    var emptyBooksLoadingView: () -> EmptyBooksLoadingView
    
    /// View to handle state when list is empty and error occurred at the first time loading
    var emptyErrorView: (Error) -> EmptyErrorView
    
    /// View to handle state when list is loaded and have no data
    var emptyLoadedView: () -> EmptyLoadedView
    
    /// View of an section of the list
    var contentView: () -> ContentView
    
    /// View showing at the bottom of the list
    var loadMoreView: (ListLoadingState.LoadMoreStatus) -> LoadMoreView
    
    // MARK: - Initializer
    
    /// PaginatedListView's initializer
    /// - Parameters:
    ///   - viewModel: ViewModel to handle data flow
    ///   - presentationStyle: Presenation type of the list
    ///   - emptyBooksLoadingView: View when list is empty and is loading (ProgressView or Skeleton)
    ///   - emptyErrorView: View when list is empty and error occured
    ///   - emptyLoadedView: View when list is loaded and have no data
    ///   - contentView: Content view of the list
    ///   - loadMoreView: View showing at the bottom of the list (ex: load more)
    init(
        viewModel: ViewModel,
        presentationStyle: ListViewPresentationStyle = .lazyVStack,
        @ViewBuilder emptyBooksLoadingView: @escaping () -> EmptyBooksLoadingView,
        @ViewBuilder emptyErrorView: @escaping (Error) -> EmptyErrorView,
        @ViewBuilder emptyLoadedView: @escaping () -> EmptyLoadedView,
        @ViewBuilder contentView: @escaping () -> ContentView,
        @ViewBuilder loadMoreView: @escaping (ListLoadingState.LoadMoreStatus) -> LoadMoreView
    ) {
        self.viewModel = viewModel
        self.presentationStyle = presentationStyle
        self.emptyBooksLoadingView = emptyBooksLoadingView
        self.emptyErrorView = emptyErrorView
        self.emptyLoadedView = emptyLoadedView
        self.contentView = contentView
        self.contentView = contentView
        self.loadMoreView = loadMoreView
    }
    
    /// MARK: - View Buidler
    
    /// Body of the view
    var body: some View {
        switch viewModel.state {
        case .empty(let status):
            VStack {
                Spacer()
                
                switch status {
                case .loading:
                    emptyBooksLoadingView()
                case .loaded:
                    emptyLoadedView()
                case .error(let error):
                    emptyErrorView(error)
                }
                
                Spacer()
            }
                .task {
                    await viewModel.reload()
                }
        case .nonEmpty(let loadMoreStatus):
            switch presentationStyle {
            case .lazyVStack:
                ScrollView {
                    LazyVStack {
                        // List of items
                        contentView()
                        
                        
                        // should fetch new item
                        loadMoreView(loadMoreStatus)
                    }
                }
                    .refreshable {
                        await viewModel.refresh()
                    }
            case .list:
                List {
                    // List of items
                    contentView()
                    
                    // should fetch new items
                    loadMoreView(loadMoreStatus)
                }
                    .refreshable {
                        await viewModel.refresh()
                    }
            }
        }
    }
}
