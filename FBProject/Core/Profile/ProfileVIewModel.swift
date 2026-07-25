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
    
    func updatePremiumStatus(_ status: Bool) {
        guard let user else { return }
        
        Task {
            do {
                try await UserManager.shared.updateIsPremiumStatus(to: status, for: user.id)
                
                self.user = try await UserManager.shared.getUser(id: user.id)
            } catch {
                print("Failed to update is premium:\n", error)
            }
        }
    }
}
