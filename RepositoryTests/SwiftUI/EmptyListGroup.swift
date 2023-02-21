//
//  EmptyListGroup.swift
//  RepositoryTests
//
//  Created by Chung Tran on 21/02/2023.
//

import SwiftUI

struct EmptyListGroup: View {
    let status: ListLoadingState.Status
    let reloadAction: () async -> Void
    
    var body: some View {
        HStack {
            Spacer()
            switch status {
            case .loading:
                LoadingView()
            case .loaded:
                NothingFoundView {
                    Task {
                        await reloadAction()
                    }
                }
            case .error:
                GeneralErrorView {
                    Task {
                        await reloadAction()
                    }
                }
            }
            Spacer()
        }
            .frame(minHeight: 200)
    }
}

struct EmptyListGroup_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListGroup(status: .loaded) {}
    }
}
