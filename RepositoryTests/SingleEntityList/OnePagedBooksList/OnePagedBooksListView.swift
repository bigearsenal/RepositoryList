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
        // Empty state
        if viewModel.data.isEmpty {
            VStack {
                Spacer()
                
                // initial loading
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                // initial error
                else if viewModel.error != nil {
                    VStack {
                        Spacer()
                        Button("Something is broken. Tap to try again") {
                            Task {
                                await viewModel.reload()
                            }
                        }
                        Spacer()
                    }
                }
                
                // empty view
                else {
                    Button("Empty") {
                        Task {
                            await viewModel.reload()
                        }
                    }
                }
                
                Spacer()
            }
                .task {
                    await viewModel.reload()
                }
        }
        
        // Non-empty state
        else {
            List {
                // List of items
                ForEach(viewModel.data) { book in
                    Text(book.name)
                }
                
//                // should fetch new item
//                if viewModel.repository.shouldFetch() {
//                    // Loading at the end of the list
//                    if viewModel.error == nil {
//                        Text("Fetching more...")
//                            .task {
//                                await viewModel.fetchNext()
//                            }
//                    }
//
//                    // Error at the end of the list
//                    else {
//                        Button("Error fetching more item... Tap to try again") {
//                            Task {
//                                await viewModel.fetchNext()
//                            }
//                        }
//                    }
//                }
//
//                else {
//                    Text("End of list")
//                }
            }
//            .overlay(
//                HStack {
//                    Spacer()
//                    VStack {
//                        Spacer()
//                        if viewModel.error != nil {
//                            Text("Error!")
//                                .foregroundColor(.red)
//                        }
//                        Text("Page: \(viewModel.repository.currentPage)")
//                    }
//                }.padding()
//            )
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

struct OnePagedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        OnePagedBooksListView()
    }
}
