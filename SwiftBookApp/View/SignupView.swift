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
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Welcome")
                    .padding(40)
                    .font(Font.largeTitle)
                    .background(Color("GreenButton"))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    
                Text("Create an account")
                    .font(Font.title)
                    .bold()
                    .padding(.bottom, 20)
                
                VStack() {
                    VStack(alignment: .leading, spacing: 15){
                        Text("Enter Username")
                        .font(Font.title2)
                        .bold()
                        TextField("", text: $signupVM.username)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.leading, 20)
                        
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Enter Email")
                            .font(Font.title2)
                            .bold()
                        TextField("", text: $signupVM.email)
                            .textFieldStyle(.roundedBorder)
                            
                    }
                    .padding(.leading, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Enter Password")
                            .font(Font.title2)
                            .bold()
                        TextField("", text: $signupVM.password)
                            .textFieldStyle(.roundedBorder)
                            
                    }
                    .padding(.leading, 20)
                    if !signupVM.hasError.isEmpty {
                        Text(signupVM.hasError)
                            .foregroundColor(.red)
                    }
                    
                }
                Button("Signup") {
                    signupVM.signUp(email: signupVM.email, password: signupVM.password, username: signupVM.username, mainVM: mainVM)
                }
                .font(Font.title3)
                .padding(10)
                .background(Color("GreenButton"))
                .foregroundColor(.white)
                .cornerRadius(10)
                
                
                Button("Already have an account? Login") {
                    mainVM.signedUp = true
                    mainVM.isLoggedIn = false
                }
                Spacer()
            }
        
            
        }
    }
        
}

#Preview {
    SignupView()
}

