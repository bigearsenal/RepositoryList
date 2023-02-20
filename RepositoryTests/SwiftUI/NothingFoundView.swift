//
//  NothingFoundView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 20/02/2023.
//

import SwiftUI

struct NothingFoundView: View {
    let reloadAction: () -> Void
    
    init(reloadAction: @escaping () -> Void) {
        self.reloadAction = reloadAction
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "binoculars")
                .font(.largeTitle)
            
            Text("Nothing found")
            
            Button("Reload") {
                reloadAction()
            }
        }
    }
}

struct NothingFoundView_Previews: PreviewProvider {
    static var previews: some View {
        NothingFoundView {}
    }
}
