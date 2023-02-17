//
//  OnePagedBooksListView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import SwiftUI

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

struct OnePagedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        OnePagedBooksListView()
    }
}
