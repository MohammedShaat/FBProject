//
//  FirestoreManager.swift
//  FBProject
//
//  Created by Mohammed on 7/25/26.
//

import FirebaseFirestore
import FirebaseSharedSwift
import Foundation

struct Movie: Codable {
    let id: String
    let name: String
    let year: Int
}

struct DBUser: Codable {
    let id: String
    let isAnonymous: Bool
    let email: String?
    let createdAt: Date
    let isPremium: Bool
    let preferences: [String]
    let favoriteMovie: Movie?
    
    init(from userAuth: UserAuth) {
        self.id = userAuth.id
        self.isAnonymous = userAuth.isAnonymous
        self.email = userAuth.email
        self.createdAt = .now
        self.isPremium = false
        self.preferences = []
        self.favoriteMovie = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case isAnonymous = "is_anonymous"
        case email
        case createdAt = "created_at"
        case isPremium = "is_premium"
        case preferences
        case favoriteMovie = "favorite_movie"
    }
}

final class UserManager {
    static let shared = UserManager()

    private let usersCollection = Firestore.firestore().collection("users")
    private func userDoc(_ id: String) -> DocumentReference {
        usersCollection.document(id)
    }
    private func favoriteCollection(for userId: String) -> CollectionReference {
        userDoc(userId).collection("favorite_products")
    }
    private func favoriteProdcutDoc(favoriteProductId: String, for userId: String) -> DocumentReference {
        favoriteCollection(for: userId).document(favoriteProductId)
    }
    private var favoriteProductsListener: ListenerRegistration?
    
    private init() {}
    
    func CreateUser(user: DBUser) async throws {
        try userDoc(user.id).setData(from: user)
    }
    
    func getUser(id: String) async throws -> DBUser {
        try await userDoc(id).getDocument(as: DBUser.self)
    }
    
    func updateIsPremiumStatus(to status: Bool, for userId: String) async throws {
        let fields: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue: status
        ]
        try await userDoc(userId).updateData(fields)
    }
    
    func addPreference(_ preference: String, to userId: String) async throws {
        let fields: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayUnion([preference])
        ]
        try await userDoc(userId).updateData(fields)
    }
    
    func removePreference(_ preference: String, to userId: String) async throws {
        let fields: [String: Any] = [
            DBUser.CodingKeys.preferences.rawValue: FieldValue.arrayRemove([preference])
        ]
        try await userDoc(userId).updateData(fields)
    }
    
    func addMovie(_ movie: Movie, to userId: String) async throws {
        let data = try Firestore.Encoder().encode(movie)
        
        let fields: [String: Any] = [
            DBUser.CodingKeys.favoriteMovie.rawValue: data
        ]
        try await userDoc(userId).updateData(fields)
    }
    
    func removeMovie(from userId: String) async throws {
        let fields: [String: Any?] = [
            DBUser.CodingKeys.favoriteMovie.rawValue: nil
        ]
        try await userDoc(userId).updateData(fields as [String : Any])
    }
    
    func addFavoriteProduct(productId: String, to userId: String) throws {
        let favoriteProduct = FavoriteProduct(productId: productId, createdAt: .now)
        try favoriteCollection(for: userId).document(productId).setData(from: favoriteProduct)
    }
    
    func removeFavoriteProduct(id productId: String, from userId: String) async throws {
        try await favoriteProdcutDoc(favoriteProductId: productId, for: userId).delete()
    }
    
    func getFavoriteProducts(for userId: String, limit count: Int, after lastFavoriteSnapshot: DocumentSnapshot?) async throws ->
    (decodables: [FavoriteProduct], lastDocSnap: DocumentSnapshot?) {
        
        try await favoriteCollection(for: userId)
            .limit(to: count)
            .startAfter(lastFavoriteSnapshot)
            .getDocumentsWithSnapshot()
    }
    
    func addListenerToFavoriteProducts(for userId: String, onRemoved: @escaping (FavoriteProduct) -> Void) {
        favoriteProductsListener = favoriteCollection(for: userId).addSnapshotListener { querySnapshot, error in
            guard let querySnapshot else { return }
            
            querySnapshot.documentChanges.forEach { docChange in
                if docChange.type == .removed,
                   let favoriteProduct = try? docChange.document.data(as: FavoriteProduct.self) {
                    onRemoved(favoriteProduct)
                }
            }
        }
    }
    
    func addListenerToFavoriteProductsWithAsync(for userId: String) -> AsyncStream<FavoriteProduct> {
        AsyncStream { continuation in
            addListenerToFavoriteProducts(for: userId) { removedFavoriteProduct in
                continuation.yield(removedFavoriteProduct)
            }
        }
    }
    
    func removeListenerForFavoriteProducts() {
        favoriteProductsListener?.remove()
        favoriteProductsListener = nil
    }
}
