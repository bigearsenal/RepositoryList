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
    @State var presentationStyle: ListViewPresentationStyle = .list
    
    var body: some View {
        ListView(
            viewModel: viewModel,
            presentationStyle: presentationStyle,
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
                VStack(spacing: 20) {
                    Image(systemName: "wrongwaysign")
                        .font(.largeTitle)
                    
                    Text("Something went wrong")
                    
                    Button("Retry") {
                        Task {
                            await viewModel.reload()
                        }
                    }
                }
            },
            emptyLoadedView: {
                VStack(spacing: 20) {
                    Image(systemName: "binoculars")
                        .font(.largeTitle)
                    
                    Text("Nothing found")
                    
                    Button("Retry") {
                        Task {
                            await viewModel.reload()
                        }
                    }
                }
            },
            itemView: { book in
                Text(book.name)
            }
        )
            .overlay(
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Button("ListViewPresentationStyle: \(presentationStyle.rawValue)") {
                            if presentationStyle == .list { presentationStyle = .lazyVStack }
                            else { presentationStyle = .list }
                        }
                    }
                }.padding()
            )
    }
}

struct OnePagedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        OnePagedBooksListView()
    }
}
