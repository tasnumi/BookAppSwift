//
//  BookstoreModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation

//this file will store information related to the bookstore that we retrieve from the map
struct Bookstore: Identifiable {
    let id: UUID
    
    let name: String
    let address: String
    
}
