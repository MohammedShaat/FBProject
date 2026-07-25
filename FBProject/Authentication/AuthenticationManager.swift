//
//  AuthenticationManager.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
//

import FirebaseAuth
import Foundation

struct UserAuth {
    let id: String
    let email: String?
    let photo: String?
    let isAnonymous: Bool
    
    init(from user: User) {
        self.id = user.uid
        self.email = user.email
        self.photo = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    func isUserAuthenticated() -> Bool {
        auth.currentUser != nil
    }
    
    func getUserData() -> UserAuth? {
        guard let user = auth.currentUser else { return nil }
        return UserAuth(from: user)
    }
    	
    func signOut() throws {
        try auth.signOut()
    }
    
    func createUser(email: String, password: String) async throws -> UserAuth {
        try await auth.createUser(withEmail: email, password: password)
        return UserAuth(from: auth.currentUser!)
    }
    
    func signInUser(email: String, password: String) async throws -> UserAuth {
        let authDataResult = try await auth.signIn(withEmail: email, password: password)
        return UserAuth(from: authDataResult.user)
    }
    
    func signInAnonymous() async throws -> UserAuth {
        let authDataResult = try await auth.signInAnonymously()
        return UserAuth(from: authDataResult.user)
    }
    
    func deleteUser() async throws {
        guard let user = auth.currentUser else {
            throw URLError(.cannotFindHost)
        }
        try await user.delete()
    }
    
    
    
    private func signInWithCredential(_ credential: AuthCredential) async throws -> UserAuth {
        let authDataResult = try await auth.signIn(with: credential)
        return UserAuth(from: authDataResult.user)
    }
    
    func signInWithGoogle(tokens: GoogleTokens) async throws -> UserAuth {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signInWithCredential(credential)
    }
    
    func signInWithApple(tokens: AppleTokens) async throws -> UserAuth {
        let credential = OAuthProvider.appleCredential(withIDToken: tokens.idToken, rawNonce: tokens.rawNonce, fullName: tokens.fullName)
        return try await signInWithCredential(credential)
    }
    
    
    
    func linkGoogle(tokens: GoogleTokens) async throws -> UserAuth {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await linkCredential(credential)
    }
    
    func linkApple(tokens: AppleTokens) async throws -> UserAuth {
        let credential = OAuthProvider.appleCredential(withIDToken: tokens.idToken, rawNonce: tokens.rawNonce, fullName: tokens.fullName)
        return try await linkCredential(credential)
    }
    
    private func linkCredential(_ credential: AuthCredential) async throws -> UserAuth {
        guard let user = auth.currentUser else {
            throw URLError(.cannotFindHost)
        }
        
        let authDataResult = try await user.link(with: credential)
        return UserAuth(from: authDataResult.user)
    }
}
