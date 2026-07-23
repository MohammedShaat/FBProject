//
//  EmailSignUpView.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
//

import SwiftUI

@Observable
final class EmailSignUpdateViewModel {
    var email: String = ""
    var password: String = ""
    
    func signUp(onSuccess: @escaping () -> Void) {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        Task {
            do {
                let userData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                onSuccess()
                print("User created")
                print(userData)
            } catch {
                print("Failed to create user", error)
            }
        }
    }
    
    func signIn(onSuccess: @escaping () -> Void) {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        Task {
            do {
                let userData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                onSuccess()
                print("User signed in")
                print(userData)
            } catch {
                print("Failed to sign in user", error)
            }
        }
    }
}

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
