//
//  AppleSignInButtonViewRepresentable.swift
//  FBProject
//
//  Created by Mohammed on 7/23/26.
//

import AuthenticationServices
import SwiftUI


struct AppleSignInButtonViewRepresentable: UIViewRepresentable {
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: type, style: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}
