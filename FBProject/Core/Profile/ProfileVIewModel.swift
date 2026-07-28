//
//  ProfileVIewModel.swift
//  FBProject
//
//  Created by Mohammed on 7/25/26.
//

import Foundation

@Observable
final class ProfileViewModel {
    var user: DBUser?
    var isPreimum: Bool {
        get { user?.isPremium ?? false }
        set {
            updatePremiumStatus(newValue)
        }
    }
    let preferenceOptions = ["sports", "books", "movies"]
    
    func loadUserData() async {
        do {
            guard let userId = AuthenticationManager.shared.getUserData()?.id else {
                print("No user id")	
                throw URLError(.cannotFindHost)
            }
            user = try await UserManager.shared.getUser(id: userId)
        } catch {
            print("Failed to load user data:\n", error)
        }
    }
    
    private func refreshUser(id: String) async throws {
        self.user = try await UserManager.shared.getUser(id: id)
    }
    
    func updatePremiumStatus(_ status: Bool) {
        guard let user else { return }
        
        Task {
            do {
                try await UserManager.shared.updateIsPremiumStatus(to: status, for: user.id)
                try await refreshUser(id: user.id)
            } catch {
                print("Failed to update is premium:\n", error)
            }
        }
    }
    
    func addPreference(_ preference: String) {
        guard let user else {
            print("No user")
            return
        }
        
        Task {
            do {
                try await UserManager.shared.addPreference(preference, to: user.id)
                try await refreshUser(id: user.id)
            } catch {
                print("Failed to add preference:\n", error)
            }
        }
    }
    
    func removePreference(_ preference: String) {
        guard let user else {
            print("No user")
            return
        }
        
        Task {
            do {
                try await UserManager.shared.removePreference(preference, to: user.id)
                try await refreshUser(id: user.id)
            } catch {
                print("Failed to remove preference:\n", error)
            }
        }
    }
    
    func addMovie() {
        guard let user else {
            print("No user")
            return
        }
        
        let movie = Movie(id: "1", name: "Shelter", year: 2026)
        
        Task {
            do {
                try await UserManager.shared.addMovie(movie, to: user.id)
                try await refreshUser(id: user.id)
            } catch {
                print("Failed to add movie:\n", error)
            }
        }
    }
    
    func removeMovie() {
        guard let user else {
            print("No user")
            return
        }
        
        Task {
            do {
                try await UserManager.shared.removeMovie(from: user.id)
                try await refreshUser(id: user.id)
            } catch {
                print("Failed to remove movie:\n", error)
            }
        }
    }
}
