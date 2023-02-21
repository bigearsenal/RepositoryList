//
//  LoadMoreView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 20/02/2023.
//

import SwiftUI

struct LoadMoreView: View {
    let loadMoreStatus: ListLoadingState.LoadMoreStatus
    let fetchNextHandler: () async -> Void
    
    var body: some View {
        switch loadMoreStatus {
        case .loading:
            BooksLoadingView(numberOfCells: 1)
                .task {
                    await fetchNextHandler()
                }
        case .reachedEndOfList:
            Text("End of list")
        case .error:
            Button("Error fetching more item... Tap to try again") {
                Task {
                    await fetchNextHandler()
                }
            }
        }
    }
}

struct LoadMoreView_Previews: PreviewProvider {
    static var previews: some View {
        LoadMoreView(loadMoreStatus: .loading) {}
    }
}
