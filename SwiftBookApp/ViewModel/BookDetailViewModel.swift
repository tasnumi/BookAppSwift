//
//  BookDetailViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation
import Combine
import SwiftUI
import FirebaseFirestore

class BookDetailViewModel: ObservableObject {
    
    func addToFavorites(book: Book, userId: String) {
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "title": book.volumeInfo.title ?? "",
            "author": book.volumeInfo.authors?.first ?? "",
            "cover": book.volumeInfo.imageLinks?.thumbnail ?? "",
            "description": book.volumeInfo.description ?? ""
        ]
        
        db.collection("users").document(userId).collection("favorites").document(book.id).setData(data)
        //go to the database called users
        //enter the document called userid to target a specific user
        //add a subcollection called favorites
        //add a unique document to represent each unique book
        //add the data as fields in this
        //resource: https://firebase.google.com/docs/firestore/data-model
        
    }
}
