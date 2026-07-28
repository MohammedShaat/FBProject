//
//  TabbarView.swift
//  FBProject
//
//  Created by Mohammed on 7/27/26.
//

import SwiftUI

struct TabbarView: View {
    @Binding var showAuthView: Bool
    
    var body: some View {
        TabView {
            Tab("Products", systemImage: "cart") {
                NavigationStack {
                    ProductsView()
                }
            }
            
            Tab("Favorites", systemImage: "star") {
                NavigationStack {
                    FavoritesView()
                }
            }
            
            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    ProfileVIew(showAuthView: $showAuthView)
                }
            }
        }
    }
}

#Preview {
    TabbarView(showAuthView: .constant(false))
}
