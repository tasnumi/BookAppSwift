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
        Text("Login")
            .font(Font.largeTitle)
        
        VStack {
            HStack {
                Text("Enter Email")
                TextField("", text: $loginVM.email)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
            
            HStack {
                Text("Enter Password")
                TextField("", text: $loginVM.password)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            }
        }
        if !loginVM.hasError.isEmpty {
            Text(loginVM.hasError)
                .foregroundColor(.red)
        }
        Button("Login") {
            loginVM.login(mainVM: mainVM)
            print(mainVM.isLoggedIn)
        }
    }
}
