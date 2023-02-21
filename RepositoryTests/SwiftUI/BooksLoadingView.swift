//
//  BooksLoadingView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 20/02/2023.
//

import SwiftUI

struct BooksLoadingView: View {
    let numberOfCells: Int
    
    init(numberOfCells: Int = 5) {
        self.numberOfCells = numberOfCells
    }
    
    var body: some View {
        ForEach(0..<numberOfCells, id: \.self) { id in
            BookView(book: .init(id: id, name: "Test"), isLoading: true)
        }
    }
}

struct BooksLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        BooksLoadingView()
    }
}
