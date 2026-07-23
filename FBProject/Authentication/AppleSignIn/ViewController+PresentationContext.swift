//
//  File.swift
//  FBProject
//
//  Created by Mohammed on 7/23/26.
//

import AuthenticationServices
import UIKit

extension UIViewController: @retroactive ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
