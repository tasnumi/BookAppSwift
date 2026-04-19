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
        // must check if the imagelink starts with http or https and set isAsset accordingly
        // using hasprefix to check for http https://www.hackingwithswift.com/read/24/3/working-with-strings-in-swift
        let imageLink = book.volumeInfo.imageLinks?.thumbnail ?? ""
        var isAsset: Bool
        if imageLink.hasPrefix("http"){
            isAsset = false
        }
        else {
            isAsset = true
        }
        let data: [String: Any] = [
            "title": book.volumeInfo.title ?? "",
            "authors": book.volumeInfo.authors ?? [],
            "cover": book.volumeInfo.imageLinks?.thumbnail ?? "",
            "description": book.volumeInfo.description ?? "",
            "isAsset": isAsset,
            "averageRating": book.volumeInfo.averageRating ?? 0.0,
        ]
        
        db.collection("users").document(userId).collection("favorites").document(book.id).setData(data)
        //go to the database called users
        //enter the document called userid to target a specific user
        //add a subcollection called favorites
        //add a unique document to represent each unique book
        //add the data as fields in this
        //resource: https://firebase.google.com/docs/firestore/data-model
    }
    
    // functionality for the user to mark the book as read
    func markAsRead(book: Book, userId: String) {
        let db = Firestore.firestore()
        let imageLink = book.volumeInfo.imageLinks?.thumbnail ?? ""
        var isAsset: Bool
        if imageLink.hasPrefix("http"){
            isAsset = false
        }
        else {
            isAsset = true
        }
        let data: [String: Any] = [
            "title": book.volumeInfo.title ?? "",
            "authors": book.volumeInfo.authors ?? [],
            "cover": book.volumeInfo.imageLinks?.thumbnail ?? "",
            "description": book.volumeInfo.description ?? "",
            "isAsset": isAsset,
            "averageRating": book.volumeInfo.averageRating ?? 0.0,
        ]
        
        // add to a subcollection called readBooks
        db.collection("users").document(userId).collection("readBooks").document(book.id).setData(data)
    }
    
     
    func removeFromFavorites(currentBook: Book, userId: String) {
        let db = Firestore.firestore()
        
        // function to delete a document in firestore https://www.hackingwithswift.com/forums/swiftui/firestore-delete/8831
        let docRef = db.collection("users").document(userId).collection("favorites").document(currentBook.id)
        docRef.delete() { (error) in
            if let error = error {
                print("error removing document \(error)")
            } else {
                
            }
        }
    }

    func removeFromRead(currentBook: Book, userId: String) {
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(userId).collection("readBooks").document(currentBook.id)
        
        docRef.delete() { (error) in
            if let error = error {
                print("error removing document \(error)")
            } else {
               
            }
        }
    }
}
