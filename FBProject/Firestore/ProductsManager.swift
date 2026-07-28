//
//  ProductsManager.swift
//  FBProject
//
//  Created by Mohammed on 7/26/26.
//

import FirebaseFirestore
import FirebaseSharedSwift
import Foundation

final class ProductsManager {
    static let shared = ProductsManager()
    
    private let productsCollection = Firestore.firestore().collection("products")
    private func productDocRef(_ id: String) -> DocumentReference {
        productsCollection.document(id)
    }
    
    private let orderKey = { (sortOption: SortOptions) in
        switch sortOption {
        case .defaultOrder: ""
        case .price: Product.CodingKeys.price.rawValue
        case .rate: Product.CodingKeys.rating.rawValue
        }
    }
    
    private init() {}
    
    func CreateProduct(product: Product) async throws {
        try productDocRef(String(product.id)).setData(from: product)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocRef(productId).getDocument(as: Product.self)
    }
    
    private func getAllProductsQuery() -> Query {
        productsCollection
    }
    
    private func getProductsSortedQuery(sortOption: SortOptions, descending: Bool) -> Query {
        return productsCollection
            .order(by: orderKey(sortOption), descending: descending)
    }
    
    private func getProductsFilteredQuery(categoryOption: CategoryOptions) -> Query {
        let fieldKey = Product.CodingKeys.category.rawValue
        let fieldValue = categoryOption.rawValue
        
        return productsCollection
            .whereField(fieldKey, isEqualTo: fieldValue)
    }
    
    private func getProductsFilteredAndSortedQuery(categoryOption: CategoryOptions, sortOption: SortOptions, descending: Bool) -> Query {
        let fieldKey = Product.CodingKeys.category.rawValue
        let fieldValue = categoryOption.rawValue
        
        return productsCollection
            .whereField(fieldKey, isEqualTo: fieldValue)
            .order(by: orderKey(sortOption), descending: descending)
    }
    
    func getProducts(categoryOption: CategoryOptions, sortOption: SortOptions, descending: Bool, count limit: Int, lastDocumentSnapshot: DocumentSnapshot?) async throws ->
    (decodables: [Product], lastDocSnap: DocumentSnapshot?) {
        
        var query = getAllProductsQuery()
        
        if categoryOption != .all && sortOption != .defaultOrder {
            query = getProductsFilteredAndSortedQuery(categoryOption: categoryOption, sortOption: sortOption, descending: descending)
        } else if categoryOption != .all {
            query = getProductsFilteredQuery(categoryOption: categoryOption)
        } else if sortOption != .defaultOrder {
            query = getProductsSortedQuery(sortOption: sortOption, descending: descending)
        }
        
        return try await query
            .limit(to: limit)
            .startAfter(lastDocumentSnapshot)
            .getDocumentsWithSnapshot()
    }
    
    func getProductsById(ids productIds: [String]) async throws -> [Product] {
        var products: [Product] = []
        for ids in productIds.chuncks(size: 30) {
            guard !ids.isEmpty else { break }
            
            if let chucnk: [Product] = try? await getAllProductsQuery()
                .whereField(FieldPath.documentID(), in: ids)
                .getDocuments() {
                products.append(contentsOf: chucnk)
            }
        }
        return products
    }
}

enum CategoryOptions: String, CaseIterable {
    case all, beauty, furniture, groceries
}

enum SortOptions: String, CaseIterable {
    case defaultOrder = "default order"
    case price, rate
}




struct ProductsResult: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

struct Product: Identifiable, Codable, Equatable {
    let id: Int
    let title: String?
    let description: String?
    let price: Double?
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let brand, category: String?
    let thumbnail: String?
    let images: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case discountPercentage
        case rating
        case stock
        case brand
        case category
        case thumbnail
        case images
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct FavoriteProduct: Codable {
    let productId: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_it"
        case createdAt = "created_at"
    }
}
