//
//  OnePagedBooksListView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import SwiftUI

struct SingleEntityListView: View {
    @State var selectedType = 0
    var examples = ["OnePaged", "Pagination", "Sectioned"]
    
    var body: some View {
        VStack {
            // Picker
            Picker("Options", selection: $selectedType) {
                ForEach(0 ..< examples.count, id: \.self) { index in
                    Text(self.examples[index])
                        .tag(index)
                }

            }.pickerStyle(SegmentedPickerStyle())
            
            // View
            switch selectedType {
            case 0:
                OnePagedBooksListView()
            case 1:
                PaginatedBooksListView()
            default:
                EmptyView()
            }
            
            Spacer()
        }
    }
}

struct SingleEntityListView_Previews: PreviewProvider {
    static var previews: some View {
        SingleEntityListView()
    }
}
