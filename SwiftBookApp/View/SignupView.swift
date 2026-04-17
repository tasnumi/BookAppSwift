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
                    .padding(30)
                    .font(Font.largeTitle)
                    .foregroundStyle(Color("GreenButton"))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .bold()

                Text("Create an account")
                    .font(Font.title)
                    .bold()
                    .padding(.bottom, 20)
                    .foregroundStyle(Color("GreenButton"))
                
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 8){
                        Text("Enter Username")
                        .font(Font.title2)
                        .bold()
                        .padding(15)
                        .foregroundStyle(Color("GreenButton"))
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(.gray)
                            TextField("Jane Doe", text: $signupVM.username)
                                .textFieldStyle(.plain)
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay (
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .frame(alignment: .leading)
                        
                    }
                    .padding(.leading, 20)
                        
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter Email")
                            .font(Font.title2)
                            .bold()
                            .padding(15)
                            .foregroundStyle(Color("GreenButton"))
                        HStack {
                            Image(systemName: "envelope")
                                    .foregroundColor(.gray)
                            TextField("janedoe@ gmail.com", text: $signupVM.email)
                                .textFieldStyle(.plain)
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay (
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .frame(alignment: .leading)
                        
                            
                    }
                    .padding(.leading, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter Password")
                            .font(Font.title2)
                            .bold()
                            .padding(15)
                            .foregroundStyle(Color("GreenButton"))
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            TextField("", text: $signupVM.password)
                                .textFieldStyle(.plain)
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay (
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .frame(alignment: .leading)
                        
                            
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 15)
                    
                    if !signupVM.hasError.isEmpty {
                        Text(signupVM.hasError)
                            .foregroundColor(.red)
                    }
                    
                }
                Button("Signup") {
                    signupVM.signUp(email: signupVM.email, password: signupVM.password, username: signupVM.username, mainVM: mainVM)
                }
                .font(Font.title3)
                .padding(.horizontal, 25)
                .padding(.vertical, 15)
                .bold()
                .background(Color("GreenButton"))
                .foregroundColor(.white)
                .cornerRadius(10)
                
                
                Button("Already have an account? Login") {
                    mainVM.signedUp = true
                    mainVM.isLoggedIn = false
                }
                .font(Font.title3)
                Spacer()
            }
        
            
        }
    }
        
}

#Preview {
    SignupView()
}

