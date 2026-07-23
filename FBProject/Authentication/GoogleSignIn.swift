//
//  GoogleAuth.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
//

import GoogleSignIn
import Foundation

struct GoogleTokens {
    let idToken: String
    let accessToken: String
}

final class GoogleSignIn {
    static let shared = GoogleSignIn()
    private init() {}
    
    func signIn() async throws -> GoogleTokens {
        guard let topVC = UIApplication.shared.topViewController else {
            throw URLError(.badURL)
        }
        
        let gidresult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidresult.user.idToken?.tokenString else {
            print("No id token")
            throw URLError(.badURL)
        }
        let accessToken = gidresult.user.accessToken.tokenString
        
        return GoogleTokens(idToken: idToken, accessToken: accessToken)
    }
}
