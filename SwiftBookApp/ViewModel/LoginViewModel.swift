//
//  LoginViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @ObservedObject var mainVM: MainAppViewModel
    @Published var username: String = "" //store the users inputted username
    @Published var password: String = "" //store the users inputted password
    @Published var email: String = "" //store the users inputted email
    @Published var hasError: String = ""
    //every time these values change, the place that observes this class will have the updated values
    
    init(mainVM: MainAppViewModel) {
        self.mainVM = mainVM
    }
    
    func login(username: String, password: String, email: String) {
        //apple documentation to find the first user which equals to the inputted username, password, and email
        if let userInfo = mainVM.users.first(where: { $0.username == username && $0.password == password && $0.email == email }) { //https://developer.apple.com/documentation/swift/array/first(where:)
            mainVM.currentUser = userInfo
            mainVM.isLoggedIn = true
            
        }
        else { //login
            signup(username: username, password: password, email: email)
        }
    }
    
    func signup(username: String, password: String, email: String) {
        if mainVM.users.contains(where: { $0.username == username || $0.email == email }) {
            Text("User already exists")
        }
        else {
            let newUser = User(username: username, email: email, password: password)
            mainVM.users.append(newUser)
        }
        
    }
}
