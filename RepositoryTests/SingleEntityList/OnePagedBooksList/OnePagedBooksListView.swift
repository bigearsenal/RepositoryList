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
    
    @State var selectedPresentationStyle = ListViewPresentationStyle.list
    var presentationStyles: [ListViewPresentationStyle] = [.list, .lazyVStack]
    
    var body: some View {
        ListView(
            viewModel: viewModel,
            presentationStyle: selectedPresentationStyle,
            emptyLoadingView: {
                // Skeleton may appear here
                LoadingView()
            },
            emptyErrorView: { _ in
                // Error like network error may appear here
                GeneralErrorView(reloadAction: {
                    Task {
                        await viewModel.reload()
                    }
                })
            },
            emptyLoadedView: {
                // Nothing found scene may appear here
                NothingFoundView {
                    Task {
                        await viewModel.reload()
                    }
                }
            },
            contentView: {
                ForEach(viewModel.data) { book in
                    BookView(book: book)
                }
            }
        )
            .overlay(
                VStack {
                    Spacer()
                    // Picker
                    Picker("PresentationStyle", selection: $selectedPresentationStyle) {
                        ForEach(presentationStyles, id: \.self) { item in
                            Text(item.rawValue)
                                .tag(item)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }.padding()
            )
    }
}

struct OnePagedBooksListView_Previews: PreviewProvider {
    static var previews: some View {
        OnePagedBooksListView()
    }
}
