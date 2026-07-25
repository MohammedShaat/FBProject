//
//  RootView.swift
//  FBProject
//
//  Created by Mohammed on 7/22/26.
//

import SwiftUI

struct RootView: View {
    @State private var showAuthView = false
    
    var body: some View {
        ZStack {
            if !showAuthView {
                NavigationStack {
                    ProfileVIew(showAuthView: $showAuthView)
                }
            }
        }
        .onAppear {
            showAuthView = !AuthenticationManager.shared.isUserAuthenticated()
        }
        .fullScreenCover(isPresented: $showAuthView) {
            AuthenticationView(showAuthView: $showAuthView)
        }
    }
}

#Preview {
    RootView()
}
