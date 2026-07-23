//
//  SettingsView.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
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
                let userData = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
                isAnonymous = userData.isAnonymous
            } catch {
                print("Failed to link Google:\n", error)
            }
        }
    }
    
    func linkApple() {
        Task {
            do {
                let tokens = try await AppleSignIn().signIn()
                let userData = try await AuthenticationManager.shared.linkApple(tokens: tokens)
                isAnonymous = userData.isAnonymous
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

struct SettingsView: View {
    @Binding var showAuthView: Bool
    
    @State private var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            Button {
                viewModel.logOut() {
                    showAuthView.toggle()
                }
            } label: {
                ActionButtonLabelView(title: "Sign Out")
            }
            
            Divider()
            
            if viewModel.isAnonymous {
                Button {
                    viewModel.linkGoogle()
                } label: {
                    ActionButtonLabelView(title: "Sign in with Google")
                }
                
                Button {
                    viewModel.linkApple()
                } label: {
                    ActionButtonLabelView(title: "Sign in with Apple")
                }
            }
            
            Divider()
            
            Button(role: .destructive) {
                viewModel.deleteAccount() {
                    showAuthView.toggle()
                }
            } label: {
                ActionButtonLabelView(title: "Delete Account", backgroundColor: .red)
            }
        }
        .padding()
    }
}

#Preview {
    SettingsView(showAuthView: .constant(false))
}
