//
//  SignupViewModel.swift
//  BookProject
//
//  Created by Tasnim Haque on 3/20/26.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import Firebase

class SignupViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var hasError: String = ""
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    func signUp(email: String, password: String, username: String, mainVM: MainAppViewModel) {
        //https://medium.com/@halluxdev/firebase-authentication-for-swift-part-2-cca8d49ee656
        auth.createUser(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    if (error.code == 17026) {
                        self.hasError = "Password should be at least 6 characters."
                        return
                    }
                    if(error.code == 17007) {
                        self.hasError = "The email address is already in use by another account."
                        return
                    }
                    print("Error code is:\(error.code)")
                    print("Error creating user: \(error.userInfo)")
                    return
                }
                
                guard let user = authResult?.user else {return}
                
                let data = ["username": username.lowercased(), "email": email, "uid": user.uid, "createdAt": Timestamp()]
                
                self.firestore.collection("users").document(user.uid).setData(data) { error in
                    if let error = error as NSError? {
                        print("DEBUG: Failed to add user to collection with \(error.code)")
                        self.hasError = "Error adding user to database. Please try again."
                        return
                    }
                    print("DEBUG: User data set.")
                }
                mainVM.signedUp = true
            }
        }
    }
}
