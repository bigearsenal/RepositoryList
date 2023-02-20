//
//  GeneralErrorView.swift
//  RepositoryTests
//
//  Created by Chung Tran on 20/02/2023.
//

import SwiftUI

struct GeneralErrorView: View {
    let reloadAction: () -> Void
    
    init(reloadAction: @escaping () -> Void) {
        self.reloadAction = reloadAction
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wrongwaysign")
                .font(.largeTitle)
            
            Text("Something went wrong")
            
            Button("Retry") {
                reloadAction()
            }
        }
    }
}

struct GeneralErrorView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralErrorView {}
    }
}
