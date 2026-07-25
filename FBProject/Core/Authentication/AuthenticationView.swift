//
//  AuthenticationView.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
//

import AuthenticationServices
import GoogleSignInSwift
import SwiftUI



struct AuthenticationView: View {
    @State private var viewModel = AuthenticationViewModel()
    
    @Binding var showAuthView: Bool
            	 
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    viewModel.signInAnonymously {
                        showAuthView.toggle()
                    }
                } label: {
                    ActionButtonLabelView(title: "Sign in Anonymously")
                }
                
                NavigationLink(destination: EmailSignUpView(showAuthView: $showAuthView)) {
                    ActionButtonLabelView(title: "Sign up with Email")
                }
                
                GoogleSignInButton(viewModel: .init(scheme: .dark, style: .wide, state: .normal)) {
                    viewModel.signInwithGoogle {
                        showAuthView.toggle()
                    }
                }
                
                Button {
                    viewModel.signInwithApple {
                        showAuthView.toggle()
                    }
                } label: {
                    AppleSignInButtonViewRepresentable(type: .default, style: .black)
                        .allowsHitTesting(false)
                }
                .frame(height: 55)
            }
            .navigationTitle("Sign Up")
            .padding()
        }
    }
}

#Preview {
    AuthenticationView(showAuthView: .constant(false))
}
