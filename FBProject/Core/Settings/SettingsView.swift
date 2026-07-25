//
//  SettingsView.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
//

import SwiftUI



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
        .navigationTitle("Settings")
        .padding()
    }
}

#Preview {
    SettingsView(showAuthView: .constant(false))
}
