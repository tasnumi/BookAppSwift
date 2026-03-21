//
//  MainAppViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import Combine
//stores main values of every page. will be published so that it can update and be passed throughout every page

class MainAppViewModel: ObservableObject {
    
    @Published var books: [Book] = []
    @Published var bookStores: [Bookstore] = []
    @Published var users: [User] = []
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    
    
}
