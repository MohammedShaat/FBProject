//
//  SettingsViewModel.swift
//  FBProject
//
//  Created by Mohammed on 7/25/26.
//


import SwiftUI

@Observable
final class SettingsViewModel {
    
    private(set) var isAnonymous: Bool
    
    init() {
        self.isAnonymous = AuthenticationManager.shared.getUserData()?.isAnonymous == true
    }
    
    func logOut(onSuccess: () -> Void) {
        do {
            try AuthenticationManager.shared.signOut()
            onSuccess()
        } catch {
            print("Failed to sign out", error)
        }
    }
    
    func linkGoogle() {
        Task {
            do {
                let tokens = try await GoogleSignIn.shared.signIn()
                let userAuth = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
                isAnonymous = userAuth.isAnonymous
            } catch {
                print("Failed to link Google:\n", error)
            }
        }
    }
    
    func linkApple() {
        Task {
            do {
                let tokens = try await AppleSignIn().signIn()
                let userAuth = try await AuthenticationManager.shared.linkApple(tokens: tokens)
                isAnonymous = userAuth.isAnonymous
            } catch {
                print("Failed to link Apple:\n", error)
            }
        }
    }
    
    func deleteAccount(onSuccess: @escaping () -> Void) {
        Task {
            do {
                try await AuthenticationManager.shared.deleteUser()
                onSuccess()
            } catch {
                print("Failed to delete account", error)
            }
        }
    }
}
