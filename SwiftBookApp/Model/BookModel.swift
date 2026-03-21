//
//  BookModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation

struct Book: Identifiable {
    let id: UUID //unique index of book items
    let title: String //title of book
    let authors: [String] //String array of authors if multiple exist
    let description: String //description of the book
    let genre: String
    let coverImage: String
    
    
}
