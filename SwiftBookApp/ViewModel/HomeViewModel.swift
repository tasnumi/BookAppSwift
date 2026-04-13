//
//  HomeViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var bookTitle: String = ""
    @Published var books: [Book] = []
    @Published var bookImage: Image? = nil
    
    func searchBook(searchItem: String) {
        print("searching for: \(searchItem)")
        let data = searchItem
        
        let urlAsString = "https://openlibrary.org/search.json?q=\(data)&limit=10" //query parameter is the inputted search string
        //additional parameter limit used to only show the 10 results
        
        let url = URL(string: urlAsString)!
        let urlSession = URLSession.shared
        
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            print("API called")
            if (error != nil) {
                print(error!.localizedDescription)
            }
            
            var err: NSError?
            
            do {
                guard let data = data else {
                    print("No data returned from API")
                    return
                }
                let decoder = JSONDecoder()
                let jsonResult = try! decoder.decode(BookResult.self, from: data)
                print(jsonResult)
                DispatchQueue.main.async {
                    self.books = jsonResult.docs
                    print("book count:", jsonResult.docs.count)
                }
            }
            catch {
                print("error: \(error)")
            }
            
        })
        jsonQuery.resume()
    }
}
