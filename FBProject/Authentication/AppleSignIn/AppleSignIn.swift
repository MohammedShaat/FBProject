//
//  AppleSignIn.swift
//  FBProject
//
//  Created by Mohammed on 7/23/26.
//

import Foundation
import CryptoKit
import UIKit
import AuthenticationServices

struct AppleTokens {
    let idToken: String
    let rawNonce: String
    let fullName: PersonNameComponents?
}

final class AppleSignIn: NSObject {
    private var currentNonce: String?
    private var completionHandler: ((Result<AppleTokens, Error>) -> Void)?
    
    func signIn() async throws -> AppleTokens {
        try await withCheckedThrowingContinuation { continuation in
            startSignInWithAppleFlow { result in
                switch result {
                case .success(let tokens):
                    continuation.resume(returning: tokens)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow(onCompletion: @escaping (Result<AppleTokens, Error>) -> Void) {
        guard let topVC = UIApplication.shared.topViewController else {
            print("There is no top view controller")
            onCompletion(.failure(URLError(.badURL)))
            return
        }
        
        completionHandler = onCompletion
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AppleSignIn: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce else {
            print("Invalid state: A login callback was received, but no login request was sent.")
            return
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        
        let tokens = AppleTokens(idToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
        completionHandler?(.success(tokens))
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        completionHandler?(.failure(error))
    }
}
