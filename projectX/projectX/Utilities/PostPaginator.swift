//
//  PostPaginator.swift
//  projectX
//
//  Created by Radomyr Bezghin on 1/5/21.
//  Copyright © 2021 Radomyr Bezghin. All rights reserved.
//

import FirebaseFirestore

class PostPaginator {
    
    private var query: Query?
    private var lastDocumentSnapshot: DocumentSnapshot?
    private var db = Firestore.firestore()
    private let documentsPerQuery = 6
    
    var isFetching = false
    
    func queryPostWith(pagination: Bool, completion: @escaping (Result<[Post], Error>) -> Void){
        if pagination {
            isFetching = true
            guard let  lastDocumentSnapshot = lastDocumentSnapshot else { return }
            query = db.posts.order(by: "date", descending: true).start(afterDocument: lastDocumentSnapshot).limit(to: documentsPerQuery)
        }else {
            query = db.posts.order(by: "date", descending: true).limit(to: documentsPerQuery)
        }
        query?.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let documents = snapshot?.documents else { return }
                let genericDocs = documents.compactMap { (querySnapshot) -> Post? in
                    return try? querySnapshot.data(as: Post.self)
                }
                completion(.success(genericDocs))
                self.lastDocumentSnapshot = snapshot!.documents.last
            }
            self.isFetching = false
        }
    }
}
