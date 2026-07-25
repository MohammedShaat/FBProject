//
//  EmailSignUpView.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
//

import SwiftUI



struct EmailSignUpView: View {
    @Binding var showAuthView: Bool
    @State private var viewModel = EmailSignUpdateViewModel()
    
    var body: some View {
        VStack {
            Form {
                TextField("Type your email", text: $viewModel.email)
                
                SecureField("Type your password", text: $viewModel.password)
                
                Button {
                    viewModel.signUp() {
                        showAuthView.toggle()
                    }
                } label: {
                    ActionButtonLabelView(title: "Sign Up")
                }
                
                Button {
                    viewModel.signIn() {
                        showAuthView.toggle()
                    }
                } label: {
                    ActionButtonLabelView(title: "Sign In")
                }
            }
        }
    }
}

#Preview {
    EmailSignUpView(showAuthView: .constant(false))
}
