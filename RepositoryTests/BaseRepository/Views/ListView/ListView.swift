import Foundation
import SwiftUI

/// Reusable list view
struct ListView<
    Repository: AnyListRepository,
    ViewModel: ListViewModel<Repository>,
    EmptyLoadingView: View,
    EmptyErrorView: View,
    EmptyLoadedView: View,
    ItemView: View,
    FooterView: View
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
    
    /// View showing at the bottom of the list
    var footerView: () -> FooterView
    
    // MARK: - Initializer
    
    /// PaginatedListView's initializer
    /// - Parameters:
    ///   - viewModel: ViewModel to handle data flow
    ///   - presentationStyle: Presenation type of the list
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
        @ViewBuilder itemView: @escaping (Repository.ItemType) -> ItemView,
        @ViewBuilder footerView: @escaping () -> FooterView
    ) {
        self.viewModel = viewModel
        self.presentationStyle = presentationStyle
        self.emptyLoadingView = emptyLoadingView
        self.emptyErrorView = emptyErrorView
        self.emptyLoadedView = emptyLoadedView
        self.itemView = itemView
        self.footerView = footerView
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
                    emptyLoadingView()
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
        case .nonEmpty:
            switch presentationStyle {
            case .lazyVStack:
                ScrollView {
                    LazyVStack {
                        // List of items
                        ForEach(viewModel.data, id: \.id) { item in
                            itemView(item)
                        }
                        
                        // should fetch new item
                        footerView()
                    }
                }
                    .refreshable {
                        await viewModel.refresh()
                    }
            case .list:
                List {
                    // List of items
                    ForEach(viewModel.data, id: \.id) { item in
                        itemView(item)
                    }
                    
                    // should fetch new items
                    footerView()
                }
                    .refreshable {
                        await viewModel.refresh()
                    }
            }
        }
    }
}
