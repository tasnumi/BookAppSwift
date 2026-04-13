//
//  LoginViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase

class LoginViewModel: ObservableObject {
    @Published var email: String = "" //store the users inputted email
    @Published var password: String = "" //store the users inputted password
    @Published var hasError: String = ""
    //every time these values change, the place that observes this class will have the updated values
    
    
    func login(mainVM: MainAppViewModel) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    print(error.code)
                    if(error.code == 17004) {
                        print(error.code)
                        self?.hasError = "Invalid credentials."
                        return
                    }
                    if(error.code == 17008) {
                        self?.hasError = "Invalid email."
                        return
                    }
                    return
                }
                mainVM.isLoggedIn = true
                self?.hasError = ""
            }
        }
    }
}
