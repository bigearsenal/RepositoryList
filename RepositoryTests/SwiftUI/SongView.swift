//
//  SongView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 21/02/2023.
//

import SwiftUI

struct SongView: View {
    let song: Song
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(systemName: song.systemImage)
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
}

struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        SongView(song: .init(name: "Song#1", systemImage: "1.circle"))
    }
}
