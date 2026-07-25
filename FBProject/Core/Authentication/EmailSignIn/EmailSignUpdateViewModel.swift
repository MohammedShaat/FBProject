//
//  EmailSignUpdateViewModel.swift
//  FBProject
//
//  Created by Mohammed on 7/25/26.
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
                let userAuth = try await AuthenticationManager.shared.createUser(email: email, password: password)
                let user = DBUser(from: userAuth)
                try await UserManager.shared.CreateUser(user: user)
                onSuccess()
                print("User created")
                print(userAuth)
            } catch {
                print("Failed to create user", error)
            }
        }
    }
    
    func signIn(onSuccess: @escaping () -> Void) {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        Task {
            do {
                let userAuth = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                onSuccess()
                print("User signed in")
                print(userAuth)
            } catch {
                print("Failed to sign in user", error)
            }
        }
    }
}
