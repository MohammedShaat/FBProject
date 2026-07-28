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
                
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(viewModel.preferenceOptions, id: \.self) { preference in
                                Button(preference) {
                                    if isPreferenced(preference: preference) {
                                        viewModel.removePreference(preference)
                                    } else {
                                        viewModel.addPreference(preference)
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(isPreferenced(preference: preference) ? .green : .gray)
                            }
                        }
                        
                        HStack {
                            Text("Preferences: ")
                            Text(user.preferences, format: .list(type: .and))
                        }
                        
                        if let movie = user.favoriteMovie {
                            HStack  {
                                Button("Remove movie", role: .destructive, action: viewModel.removeMovie)
                                Spacer()
                                HStack {
                                    Text("Name: \(movie.name)")
                                    Text("Year: \(movie.year)")
                                }
                            }
                        } else {
                            Button("Add movie", action: viewModel.addMovie)
                        }
                    }
                }
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
    
    private func isPreferenced(preference: String) -> Bool {
        viewModel.user?.preferences.contains(preference) == true
    }
}

#Preview {
    NavigationStack {
        ProfileVIew(showAuthView: .constant(false))
    }
}
