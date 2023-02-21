//
//  BookView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 20/02/2023.
//

import SwiftUI
import SkeletonUI

struct BookView: View {
    let book: Book
    let isLoading: Bool
    
    init(book: Book, isLoading: Bool = false) {
        self.book = book
        self.isLoading = isLoading
    }
    
    var body: some View {
        HStack {
            Image(systemName:
                    "\(book.id).circle")
                .resizable()
                .skeleton(with: isLoading)
                .frame(width: 40, height: 40)
                
            Text(book.name + (book.refreshedCount > 0 ? " (refreshed \(book.refreshedCount) times)": ""))
                .skeleton(with: isLoading)
                .frame(maxHeight: 40)
        }
        
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: .init(id: 1, name: "Test"))
    }
}
