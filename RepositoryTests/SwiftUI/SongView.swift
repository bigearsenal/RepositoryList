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
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white)
            .overlay(
                Text(song.id)
            )
    }
}

struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        SongView(song: .init(name: "Song#1", systemImage: "1.circle"))
    }
}
