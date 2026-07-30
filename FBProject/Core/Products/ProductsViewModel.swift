//
//  ProductsViewModel.swift
//  FBProject
//
//  Created by Mohammed on 7/26/26.
//

import Foundation
import FirebaseFirestore

@Observable
final class ProductsViewModel {
    
    private(set) var products: [Product] = []
    private(set) var loading = false
    
    private(set) var sortOption: SortOptions = .defaultOrder
    private(set) var descending = false
    private(set) var filterOption: CategoryOptions = .all
    
    private var lastDocSnap: DocumentSnapshot?
    
    private let traceForGetProduct = PerformanceManager(name: "func_get_products")
    
    func getProducts() {
        traceForGetProduct.start()
        Task {
            do {
                loading = true
                traceForGetProduct.addLog(value: "start", for: "fetch_state")
                let (newProducts, docSnap) = try await ProductsManager.shared.getProducts(categoryOption: filterOption, sortOption: sortOption, descending: descending, count: 8, lastDocumentSnapshot: lastDocSnap)
                traceForGetProduct.addLog(value: "succeeded", for: "fetch_state")
                products.append(contentsOf: newProducts)
                if let docSnap {
                    lastDocSnap = docSnap
                }
            } catch {
                print("Failed to get products:\n", error)
                traceForGetProduct.addLog(value: "Failed", for: "fetch_state")
            }
            loading = false
            traceForGetProduct.stop()
        }
    }
    
    func getProductsSorted(by sortOption: SortOptions) {
        if self.sortOption == sortOption {
            self.descending = !self.descending
        } else {
            self.descending = false
        }
        
        self.sortOption = sortOption
        clearProducts()
        getProducts()
    }
    
    func getProductsFitlered(by categroyOption: CategoryOptions) {
        self.filterOption = categroyOption
        clearProducts()
        getProducts()
    }
    
    private func clearProducts() {
        products.removeAll()
        lastDocSnap = nil
    }
    
    func addProductToFavorites(id productId: String) {
        guard let userId = AuthenticationManager.shared.getUserData()?.id else {
            print("No user found")
            return
        }
                
        Task {
            do {
                try UserManager.shared.addFavoriteProduct(productId: productId, to: userId)
            } catch {
                print("Failed to add product to favorites:\n", error)
            }
        }
    }
    
//    func downloadProductsAndUpload() {
//        guard let url = URL(string: "https://dummyjson.com/products") else {
//            print("Invalid URL")
//            return
//        }
//        
//        Task {
//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                let productsResult = try JSONDecoder().decode(ProductsResult.self, from: data)
//                let products = productsResult.products
//                print("Products: ", products.count)
//                
//                for product in products {
//                    try await ProductsManager.shared.CreateProduct(product: product)
//                }
//            } catch {
//                print("Failed to download/upload products:\n", error)
//            }
//        }
//    }
}
