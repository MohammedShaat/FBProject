//
//  File.swift
//  FBProject
//
//  Created by Mohammed on 7/28/26.
//


import FirebaseFirestore
import FirebaseSharedSwift
import Foundation

extension Query {
    func getDocumentsWithSnapshot<T: Decodable>() async throws -> (decodables: [T], lastDocSnap: DocumentSnapshot?) {
        let querySnapshot = try await self.getDocuments()
        
        let decodables = try querySnapshot.documents.map { docSnapshot in
            try docSnapshot.data(as: T.self)
        }
        return (decodables, querySnapshot.documents.last)
    }
    
    func getDocuments<T: Decodable>() async throws -> [T] {
        try await getDocumentsWithSnapshot().decodables
    }
    
    func startAfter(_ lastDocumentSnapshot: DocumentSnapshot?) -> Query {
        guard let lastDocumentSnapshot else {
            return self
        }
        return self.start(afterDocument: lastDocumentSnapshot)
    }
}