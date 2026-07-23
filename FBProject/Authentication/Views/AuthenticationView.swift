//
//  AuthenticationView.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
//

import AuthenticationServices
import GoogleSignInSwift
import SwiftUI

@Observable
final class AuthenticationViewModel {
    
    func signInwithGoogle(onSuccess: @escaping () -> Void) {
        Task {
            do {
                let gidAuth = try await GoogleSignIn.shared.signIn()
                
                _ = try await AuthenticationManager.shared.signInWithGoogle(tokens: gidAuth)
                onSuccess()
            } catch {
                print("Failed to sign in with Google", error)
            }
        }
    }
    
    func signInwithApple(onSuccess: @escaping () -> Void) {
        Task {
            do {
                let appleTokens = try await AppleSignIn().signIn()
                
                _ = try await AuthenticationManager.shared.signInWithApple(tokens: appleTokens)
                onSuccess()
            } catch {
                print("Failed to sign in with Apple", error)
            }
        }
    }
    
    func signInAnonymously(onSuccess: @escaping () -> Void) {
        Task {
            do {
                _ = try await AuthenticationManager.shared.signInAnonymous()
                onSuccess()
            } catch {
                print("Failed to sign in anonymously", error)
            }
        }
    }
}

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
