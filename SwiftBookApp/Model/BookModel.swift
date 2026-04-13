//
//  BookModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation
import SwiftUI

//struct Book: Identifiable {
//    let id: UUID //unique index of book items
//    let title: String //title of book
//    let authors: [String] //String array of authors if multiple exist
//    let description: String //description of the book
//    let genre: String
//    let coverImage: String
//    
//    
//}

struct Book: Decodable, Identifiable { //API's JSON format
    let id = UUID()
    let title: String? //title of book
    let author_name: [String]? //authors name (array in case multiple)
    let first_publish_year: Int? //published date
    let cover_i: Int? //int for cover image
}

struct BookResult: Decodable {
    let docs: [Book] //output of API is docs
}
