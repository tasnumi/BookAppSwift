//
//  SignupView.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/21/26.
//

import Foundation
import SwiftUI

struct SignupView: View {
    @StateObject var signupVM = SignupViewModel()
    @EnvironmentObject var mainVM : MainAppViewModel
    
    var body: some View {
        Text("Welcome")
            .font(Font.largeTitle)
        Text("Create an account")
            .font(Font.title)
        
        VStack {
            HStack {
                Text("Enter Username")
                TextField("", text: $signupVM.username)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            
            HStack {
                Text("Enter Email")
                TextField("", text: $signupVM.email)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            
            HStack {
                Text("Enter Password")
                TextField("", text: $signupVM.password)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            if !signupVM.hasError.isEmpty {
                Text(signupVM.hasError)
                    .foregroundColor(.red)
            }
            
        }
        Button("Signup") {
            signupVM.signUp(email: signupVM.email, password: signupVM.password, username: signupVM.username, mainVM: mainVM)
        }
        
        Button("Already have an account? Login") {
            mainVM.signedUp = true
            mainVM.isLoggedIn = false
        }
    }
}

