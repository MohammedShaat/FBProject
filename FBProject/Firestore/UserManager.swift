//
//  FirestoreManager.swift
//  FBProject
//
//  Created by Mohammed on 7/25/26.
//

import FirebaseFirestore
import FirebaseSharedSwift
import Foundation

struct DBUser: Codable {
    let id: String
    let isAnonymous: Bool
    let email: String?
    let createdAt: Date
    let isPremium: Bool
    
    init(from userAuth: UserAuth) {
        self.id = userAuth.id
        self.isAnonymous = userAuth.isAnonymous
        self.email = userAuth.email
        self.createdAt = .now
        self.isPremium = false
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case isAnonymous = "is_anonymous"
        case email
        case createdAt = "created_at"
        case isPremium = "is_premium"
    }
}

final class UserManager {
    static let shared = UserManager()

    private let db = Firestore.firestore()
    private let usersCollection: CollectionReference
    
//    private let encoder: Firestore.Encoder = {
//        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        return encoder
//    }()
//    private let decoder: Firestore.Decoder = {
//        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        return decoder
//    }()

    private init() {
        usersCollection = db.collection("users")
    }
    
    private func userDocRef(_ id: String) -> DocumentReference {
        usersCollection.document(id)
    }
    
    func CreateUser(user: DBUser) async throws {
        try userDocRef(user.id).setData(from: user)
    }
        
    func getUser(id: String) async throws -> DBUser {
        try await userDocRef(id).getDocument(as: DBUser.self)
    }
    
    func updateIsPremiumStatus(to status: Bool, for userId: String) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue: status
        ]
        try await userDocRef(userId).updateData(data)
    }
}
