//
//  SwiftBookAppApp.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/20/26.
//

import SwiftUI
import Firebase

@main
struct SwiftBookAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    @StateObject var mainVM = MainAppViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainVM)
        }
    }
}
