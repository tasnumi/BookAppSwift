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

//https://stackoverflow.com/questions/34709066/remove-objects-with-duplicate-properties-from-swift-array use this resource to
//create a function that will remove duplicates. in this case, its used to remove duplicate titles
extension Array {
    func removingDuplicates<T: Hashable>(byKey key: (Element) -> T) -> [Element] {
        var result = [Element]()
        var seen = Set<T>()
        for value in self {
            if seen.insert(key(value)).inserted {
                result.append(value)
            }
        }
        return result
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
        let cleanData = data.trimmingCharacters(in: .whitespacesAndNewlines)
        let query = cleanData.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let key = Secrets.GoogleBooksAPIKey
        print("QUERY:", query)
        let urlAsString = "https://www.googleapis.com/books/v1/volumes?q=\(query)&maxResults=10&key=\(key)"
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
                      let contentType = response as? HTTPURLResponse else { return } //https://stackoverflow.com/questions/40671991/generate-your-own-error-code-in-swift-3 use this resource to get the error code from the API to detect
                print("Status code:", contentType.statusCode)
                if(contentType.statusCode == 200) {
                    let decoder = JSONDecoder()
                    let jsonResult = try decoder.decode(GoogleBooksResponse.self, from: data)
                    print(jsonResult)
                    DispatchQueue.main.async {
                        let bookResults = jsonResult.items ?? []
                       
                        //https://stackoverflow.com/questions/27768064/check-if-swift-text-field-contains-non-whitespace
                        //use this resource to check if any of the titles, authors, or descriptions contain empty fields or whitespaces
                        //https://www.youtube.com/watch?v=-mx_Kf3qKJY use this resource to assist with filtering the array based on certain
                        //attributes
                        let filterBookResults = bookResults.filter {$0.volumeInfo.title?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false && $0.volumeInfo.authors?.isEmpty == false && $0.volumeInfo.description?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false}.removingDuplicates(byKey: {$0.volumeInfo.title?.lowercased() ?? ""})
                        self.books = filterBookResults
                        
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.mockAPIData()
                    }
                }
                
            }
            catch {
                print("error: \(error)")
            }
            
        })
        jsonQuery.resume()
    }
    
    func mockAPIData() {
        self.books = [
            Book(
                volumeInfo: VolumeInfo(
                    title: "Harry Potter and the Sorcerer's Stone",
                    authors: ["J.K. Rowling"],
                    description: "Harry Potter is an orphaned boy who discovers on his eleventh birthday that he is a wizard and has been invited to attend Hogwarts School of Witchcraft and Wizardry. There, he makes friends and uncovers the dark secrets of the magical world.",
                    imageLinks: ImageLinks(
                        thumbnail: "harry_potter",
                        isAsset: true
                    ),
                    averageRating: 4.5
                )
            ),
            Book(
                volumeInfo: VolumeInfo(
                    title: "Circe",
                    authors: ["Madeline Miller"],
                    description: "In the house of Helios, god of the sun and mightiest of the Titans, a daughter is born. Turning to the world of mortals for companionship, she discovers that she does possess power: the power of witchcraft, which can transform rivals into monsters and menace the gods themselves.",
                    imageLinks: ImageLinks(
                        thumbnail: "circe",
                        isAsset: true
                    ),
                    averageRating: 4.0
                )
            ),
            Book(
                volumeInfo: VolumeInfo(
                    title: "The Fellowship of the Ring",
                    authors: ["J.R.R. Tolkien"],
                    description: "Sauron, the Dark Lord, has gathered to him all the Rings of Power – the means by which he intends to rule Middle-earth. All he lacks in his plans for dominion is the One Ring – the ring that rules them all – which has fallen into the hands of the hobbit, Bilbo Baggins.",
                    imageLinks: ImageLinks(
                        thumbnail: "lord_of_the_rings",
                        isAsset: true
                    ),
                    averageRating: 5.0
                )
            ),
            Book(
                volumeInfo: VolumeInfo(
                    title: "Pride and Prejudice",
                    authors: ["Jane Austen "],
                    description: "Set amongst the landed gentry in the South of England, it explores contemporary anxiety around courtship, reputation and social expectations for women. The story centres on the Bennet family, whose five unmarried daughters are not in line to inherit their family estate and must therefore marry to secure their livelihoods.",
                    imageLinks: ImageLinks(
                        thumbnail: "pride_and_prejudice",
                        isAsset: true
                    ),
                    averageRating: 5.0
                )
            )
        ]
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


