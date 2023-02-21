//
//  SongsLoadingView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 21/02/2023.
//

import SwiftUI
import SkeletonUI

struct SongsLoadingView: View {
    var body: some View {
        ForEach(0..<2) { id in
            SongView(song: .init(name: "Test song", systemImage: "\(id).circle"))
                .skeleton(with: true)
                .shape(type: .rectangle)
                .frame(width: 120, height: 120)
        }
    }
}

struct SongsLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        SongsLoadingView()
    }
}
