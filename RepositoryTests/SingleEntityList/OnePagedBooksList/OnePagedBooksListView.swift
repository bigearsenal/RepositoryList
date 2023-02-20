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
