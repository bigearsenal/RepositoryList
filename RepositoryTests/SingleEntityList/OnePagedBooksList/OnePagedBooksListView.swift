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
        ListView(
            viewModel: viewModel,
            emptyLoadingView: {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
            },
            emptyErrorView: { _ in
                VStack {
                    Spacer()
                    Button("Something is broken. Tap to try again") {
                        Task {
                            await viewModel.reload()
                        }
                    }
                    Spacer()
                }
            },
            emptyLoadedView: {
                Button("Empty") {
                    Task {
                        await viewModel.reload()
                    }
                }
            },
            itemView: { book in
                Text(book.name)
            }
        )
    }
}

struct OnePagedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        OnePagedBooksListView()
    }
}
