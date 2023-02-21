//
//  EmptyBooksListGroup.swift
//  RepositoryTests
//
//  Created by Chung Tran on 21/02/2023.
//

import SwiftUI

struct EmptyBooksListGroup: View {
    let status: ListLoadingState.Status
    let reloadAction: () async -> Void
    
    var body: some View {
        switch status {
        case .loading:
            BooksLoadingView()
        case .loaded:
            HStack {
                Spacer()
                NothingFoundView {
                    Task {
                        await reloadAction()
                    }
                }
                Spacer()
            }
            .frame(minHeight: 200)
        case .error:
            HStack {
                Spacer()
                GeneralErrorView {
                    Task {
                        await reloadAction()
                    }
                }
                Spacer()
            }
            .frame(minHeight: 200)
        }
    }
}

struct EmptyBooksListGroup_Previews: PreviewProvider {
    static var previews: some View {
        EmptyBooksListGroup(status: .loaded) {}
    }
}
