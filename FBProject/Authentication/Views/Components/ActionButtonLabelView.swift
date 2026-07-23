//
//  SignButton.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
//

import SwiftUI

struct ActionButtonLabelView: View {
    let title: String
    var backgroundColor: Color = .blue
    
    var body: some View {
        Text(title)
            .padding()
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .fontWeight(.bold)
            .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ActionButtonLabelView(title: "Sign In with Email")
}
