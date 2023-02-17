//
//  ContentView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 17/02/2023.
//

import SwiftUI

struct ContentView: View {
    @State var selectedEntityType = 0
    var examples = ["Single Entity", "Multiple Entity"]
    
    var body: some View {
        VStack {
            // Picker
            Picker("Options", selection: $selectedEntityType) {
                ForEach(0 ..< examples.count, id: \.self) { index in
                    Text(self.examples[index])
                        .tag(index)
                }

            }.pickerStyle(SegmentedPickerStyle())
            
            // View
            switch selectedEntityType {
            case 0:
                SingleEntityListView()
            case 1:
                MultipleEntitiesListView()
            default:
                EmptyView()
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
