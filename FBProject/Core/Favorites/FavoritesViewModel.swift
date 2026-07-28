//
//  FavoritesViewModel.swift
//  FBProject
//
//  Created by Mohammed on 7/27/26.
//

import Foundation
import FirebaseFirestore

@Observable
final class FavoritesViewModel {
    private(set) var favorites: [Product] = []
    private(set) var loading = false
    private(set) var lastFavoriteProductSnapshot: DocumentSnapshot?
    
    func getFavorites() {
        guard let userId = AuthenticationManager.shared.getUserData()?.id else {
            print("No user found")
            return
        }
        
        Task {
            do {
                loading = true
                let (favoriteProducts, lastSnapshot) = try await UserManager.shared.getFavoriteProducts(
                    for: userId,
                    limit: 6,
                    after: lastFavoriteProductSnapshot
                )
                
                if let lastSnapshot {
                    lastFavoriteProductSnapshot = lastSnapshot
                }
                
                let ids = favoriteProducts.map { $0.productId }
                let nextProducts = try await ProductsManager.shared.getProductsById(ids: ids)
                
                favorites.append(contentsOf: nextProducts)
                
            } catch {
                print("Failed to get favorite products:\n", error)
            }
            loading = false
        }
    }
    
    func removeProductFromFavorites(id productId: String) {
        guard let userId = AuthenticationManager.shared.getUserData()?.id else {
            print("No user found")
            return
        }
        
        Task {
            do {
                try await UserManager.shared.removeFavoriteProduct(id: productId, from: userId)
            } catch {
                print("Failed to get favorite products:\n", error)
            }
        }
    }
    
    func addListenerForFavoriteProducts() {
        guard let userId = AuthenticationManager.shared.getUserData()?.id else {
            print("No user found")
            return
        }
        
        Task {
            for await removedFavoriteProduct in UserManager.shared.addListenerToFavoriteProductsWithAsync(for: userId) {
                favorites.removeAll { String($0.id) == removedFavoriteProduct.productId }
            }
        }
    }
    
    func removeListenerOfFavoriteProducts() {
        UserManager.shared.removeListenerForFavoriteProducts()
    }
}
