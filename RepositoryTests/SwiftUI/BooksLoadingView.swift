//
//  BooksLoadingView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 20/02/2023.
//

import SwiftUI

struct BooksLoadingView: View {
    var body: some View {
        ForEach(0..<5) { id in
            BookView(book: .init(id: id, name: "Test"), isLoading: true)
        }
    }
}

struct BooksLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        BooksLoadingView()
    }
}
