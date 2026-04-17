//
//  HomeViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

//use this resource: https://www.youtube.com/watch?v=6DWCZpL7fBE&t=267s
enum Secrets {
    static var GoogleBooksAPIKey: String {
        guard let key = Bundle.main.infoDictionary?["GOOGLE_BOOKS_API_KEY"] as? String else {
            fatalError("Google Books API key not found. Check Secrets.xcconfig")
        }
        return key
    }
}
class HomeViewModel: ObservableObject {
    @Published var bookTitle: String = ""
    @Published var books: [Book] = []
    @Published var bookImage: Image? = nil
    @Published var descriptionBook: String = ""
    @Published var username: String = ""
    
    func searchBook(searchItem: String) {
        print("searching for: \(searchItem)")
        let data = searchItem
        let key = Secrets.GoogleBooksAPIKey
        let urlAsString = "https://www.googleapis.com/books/v1/volumes?q=\(data)&maxResults=10&key=\(key)"
        let url = URL(string: urlAsString)!
        let urlSession = URLSession.shared

        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            print("API called")
            if (error != nil) {
                print(error!.localizedDescription)
            }
            
            var err: NSError?
            
            do {
                guard let data = data,
                      let contentType = response as? HTTPURLResponse else { return }
                print("Status code:", contentType.statusCode)
                
                let decoder = JSONDecoder()
                let jsonResult = try decoder.decode(GoogleBooksResponse.self, from: data)
                print(jsonResult)
                DispatchQueue.main.async {
                    self.books = jsonResult.items ?? []
                }
            }
            catch {
                print("error: \(error)")
            }
            
        })
        jsonQuery.resume()
    }
    
    func getUsername() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                self.username = document.data()?["username"] as? String ?? ""
                print("Username is \(self.username)")
            }
            else {
                print("Document does not exist")
            }
        }
    }//https://stackoverflow.com/questions/71006819/swiftui-get-field-value-from-a-firebase-document
}


