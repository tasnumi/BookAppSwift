//
//  ProfileViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation
import Combine
import FirebaseAuth
import SwiftUI
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    
    // array to hold favorite books
    @Published var favoriteBooks: [Book] = []
    // array to hold read books
    @Published var readBooks: [Book] = []
    
    // fetch data from firebase resource used https://peterfriese.dev/blog/2020/swiftui-firebase-fetch-data/
    // and https://www.youtube.com/watch?v=XvOgTmG86FE
    
    func fetchFavBookData() async {
        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("favorites").addSnapshotListener { (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            return
          }
            self.favoriteBooks = documents.map { queryDocumentSnapshot -> Book in
                let data = queryDocumentSnapshot.data()
                // as defined in the model, if the volume info title is "" use the document id as the id
                // how to check if a string is empty https://stackoverflow.com/questions/29381994/check-string-for-nil-empty
                let title: String
                if let stringCheck = data["title"] as? String, !stringCheck.isEmpty {
                    // if it is not empty, set title to data["title"]
                     title = stringCheck
                }
                else {
                    // else set title as the document id to use as the book identifier from profile view
                     title = queryDocumentSnapshot.documentID
                }
                //let title = data["title"] as? String ??
                let authors = data["authors"] as? [String] ?? []
                let description = data["description"] as? String ?? ""
                // in the favorites and readBooks collection, the image url is stored as the string "cover"
                // imagelinks structure from the source below
                // https://developers.google.com/books/docs/v1/reference/volumes
                let cover = data["cover"] as? String ?? ""
                let isAsset = data["isAsset"] as? Bool ?? false
                return Book(volumeInfo: VolumeInfo(title: title, authors: authors, description: description, imageLinks: ImageLinks(thumbnail: cover, isAsset: isAsset)))
            }
        }
    }
  
    func fetchReadBookData() async {
        let db = Firestore.firestore()
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("readBooks").addSnapshotListener { (querySnapshot, error) in
          guard let documents = querySnapshot?.documents else {
            return
          }
            self.readBooks = documents.map { queryDocumentSnapshot -> Book in
                let data = queryDocumentSnapshot.data()
                let title: String
                if let stringCheck = data["title"] as? String, !stringCheck.isEmpty {
                     title = stringCheck
                }
                else {
                     title = queryDocumentSnapshot.documentID
                }
                //let title = data["title"] as? String ?? ""
                let authors = data["authors"] as? [String] ?? []
                let description = data["description"] as? String ?? ""
                let cover = data["cover"] as? String ?? ""
                let isAsset = data["isAsset"] as? Bool ?? false
                return Book(volumeInfo: VolumeInfo(title: title, authors: authors, description: description, imageLinks: ImageLinks(thumbnail: cover, isAsset: isAsset)))
            }
        }
    }
}
