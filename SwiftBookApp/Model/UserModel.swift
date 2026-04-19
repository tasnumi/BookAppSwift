//
//  UserModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/19/26.
//

import Foundation
import SwiftUI
import Combine

class User: ObservableObject, Identifiable {
    let id: UUID
    let username: String
    let email: String
    let password: String
    
    @Published var favoriteBooks: [UUID]
    @Published var readBooks: [UUID]
    @Published var favoriteStores: [UUID]
    
    init(id: UUID = UUID(), username: String, email: String, password: String, favoriteBooks: [UUID] = [],  readBooks: [UUID] = [], favoriteStores: [UUID] = []) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.favoriteBooks = favoriteBooks
        self.readBooks = readBooks
        self.favoriteStores = favoriteStores
    }
    
    
}
