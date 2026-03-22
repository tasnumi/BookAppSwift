//
//  SignupViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import SwiftUI
import Combine

class SignupViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var errors: String = ""
    
    
    func Signup(mainVM: MainAppViewModel) {
        if username.isEmpty || password.isEmpty || email.isEmpty {
            errors = "Please fill out all fields"
        }
        
        if mainVM.users.contains(where: { $0.email == email  && $0.password == password && $0.username == username}) {
            errors = "User already exists"
        }
        
        let newUser = User(username: username, email: email, password: password)
        mainVM.users.append(newUser)
        mainVM.signedUp = true
        mainVM.currentUser = newUser
        //reset all fields
        username = ""
        password = ""
        email = ""
        errors = ""
    }
}
