//
//  LoginView.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/21/26.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject var loginVM = LoginViewModel()
    @EnvironmentObject var mainVM: MainAppViewModel
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack(spacing: 30) {
                Text("Welcome")
                    .padding(25)
                    .font(Font.largeTitle)
                    .foregroundStyle(Color("GreenButton"))
                    .cornerRadius(15)
                    .bold()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Email")
                        .font(Font.title2)
                        .bold()
                        .padding(15)
                        .foregroundStyle(Color("GreenButton"))
                    HStack {
                        Image(systemName: "envelope")
                                .foregroundColor(.gray)
                        TextField("", text: $loginVM.email)
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
                        TextField("", text: $loginVM.password)
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
                
                VStack {
                    if !loginVM.hasError.isEmpty {
                        Text(loginVM.hasError)
                            .foregroundColor(.red)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
                Button("Login") {
                    loginVM.login(mainVM: mainVM)
                    print(mainVM.isLoggedIn)
                }
                .font(Font.title3)
                .padding(.horizontal, 25)
                .padding(.vertical, 15)
                .bold()
                .background(Color("GreenButton"))
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Don't have an account? Signup") {
                    mainVM.signedUp = false
                    mainVM.isLoggedIn = false
                }
                .font(Font.title3)
            }
            
        }
        
        
    }
}
#Preview {
    LoginView()
}
