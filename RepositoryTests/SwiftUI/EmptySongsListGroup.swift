//
//  EmptySongsListGroup.swift
//  RepositoryTests
//
//  Created by Chung Tran on 21/02/2023.
//

import SwiftUI
import SkeletonUI

struct EmptySongsListGroup: View {
    let status: ListLoadingState.Status
    let reloadAction: () async -> Void
    
    var body: some View {
        Group {
            switch status {
            case .loading:
                ScrollView {
                    HStack {
                        SongsLoadingView()
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
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
            }
        }
            .frame(minHeight: 120)
    }
}

struct EmptySongsListGroup_Previews: PreviewProvider {
    static var previews: some View {
        EmptySongsListGroup(status: .loaded) {}
    }
}
