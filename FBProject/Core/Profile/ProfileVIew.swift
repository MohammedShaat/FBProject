//
//  ProfileVIew.swift
//  FBProject
//
//  Created by Mohammed on 7/25/26.
//

import SwiftUI

struct ProfileVIew: View {
    @Binding var showAuthView: Bool
    
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        List {
            if let user = viewModel.user {
                Text(user.id)
                
                Text("Is anonymous: \(user.isAnonymous ? "true" : "false")")
                
                Toggle("Is premium", isOn: $viewModel.isPreimum)
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showAuthView: $showAuthView)
                } label: {
                    Image(systemName: "gear")
                        .fontWeight(.bold)
                }

            }
        }
        .task {
            await viewModel.loadUserData()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileVIew(showAuthView: .constant(false))
    }
}
