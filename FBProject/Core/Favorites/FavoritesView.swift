//
//  FavoritesView.swift
//  FBProject
//
//  Created by Mohammed on 7/27/26.
//

import SwiftUI

struct FavoritesView: View {
    @State private var viewModel = FavoritesViewModel()
    @State private var firstAppear = true
    
    var body: some View {
        List {
            ForEach(viewModel.favorites) { product in
                
                ProductItemView(product: product)
                    .contextMenu(menuItems: {
                        Button("Remove from favorites") {
                            viewModel.removeProductFromFavorites(id: String(product.id))
                        }
                    })
                    .onAppear {
                        if product == viewModel.favorites.last {
                            viewModel.getFavorites()
                        }
                    }
            }
            
            if viewModel.loading {
                ProgressView()
                    .id(UUID())
                    .tint(.blue)
                    .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            print("Appeared")
            viewModel.getFavorites()
            
            if firstAppear {
                viewModel.addListenerForFavoriteProducts()
                firstAppear = false
            }
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    FavoritesView()
}
