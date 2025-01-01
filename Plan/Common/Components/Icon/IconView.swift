//
//  IconView.swift
//  Plan
//
//  Created by Joses Solmaximo on 30/01/24.
//

import SwiftUI

struct IconView: View {
    let icon: String
    let size: CGFloat
    
    init(_ icon: String, size: CGFloat = 20) {
        self.icon = icon
        self.size = size
    }
    
    var body: some View {
        Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}

#Preview {
    IconView("")
}
