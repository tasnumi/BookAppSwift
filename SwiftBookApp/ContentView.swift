//
//  ContentView.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/20/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainVM : MainAppViewModel
    var body: some View {
            if !mainVM.signedUp {
                SignupView()
            }
            else if !mainVM.isLoggedIn {
                LoginView()
            }
            else {
                HomeView()
            }
    }
}

#Preview {
    ContentView()
        .environmentObject(MainAppViewModel())
}
