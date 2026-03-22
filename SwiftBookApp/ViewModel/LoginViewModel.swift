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
    @Published var email: String = "" //store the users inputted email
    @Published var password: String = "" //store the users inputted password
    @Published var hasError: String = ""
    //every time these values change, the place that observes this class will have the updated values
    
    func login(mainVM: MainAppViewModel) {
        //apple documentation to find the first user which equals to the inputted username, password, and email
        if let userInfo = mainVM.users.first(where: { $0.password == password && $0.email == email
            
        }) {
            //https://developer.apple.com/documentation/swift/array/first(where:)
                mainVM.currentUser = userInfo
                mainVM.isLoggedIn = true
        }
        else {
            hasError = "Account doesn't exist."
        }
    }
}
