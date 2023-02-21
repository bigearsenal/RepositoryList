//
//  BookView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 20/02/2023.
//

import SwiftUI

struct BookView: View {
    let book: Book
    
    var body: some View {
        Text(book.name + (book.refreshedCount > 0 ? " (refreshed \(book.refreshedCount) times)": ""))
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: .init(id: 1, name: "Test"))
    }
}
