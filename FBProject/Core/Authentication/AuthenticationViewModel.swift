//
//  AuthenticationViewModel.swift
//  FBProject
//
//  Created by Mohammed on 7/25/26.
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
                
                let userAuth = try await AuthenticationManager.shared.signInWithGoogle(tokens: gidAuth)
                let user = DBUser(from: userAuth)
                try await UserManager.shared.CreateUser(user: user)
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
                
                let userAuth = try await AuthenticationManager.shared.signInWithApple(tokens: appleTokens)
                let user = DBUser(from: userAuth)
                try await UserManager.shared.CreateUser(user: user)
                onSuccess()
            } catch {
                print("Failed to sign in with Apple", error)
            }
        }
    }
    
    func signInAnonymously(onSuccess: @escaping () -> Void) {
        Task {
            do {
                let userAuth = try await AuthenticationManager.shared.signInAnonymous()
                let user = DBUser(from: userAuth)
                try await UserManager.shared.CreateUser(user: user)
                onSuccess()
            } catch {
                print("Failed to sign in anonymously", error)
            }
        }
    }
}
