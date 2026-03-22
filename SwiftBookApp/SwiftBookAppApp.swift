//
//  SwiftBookAppApp.swift
//  SwiftBookApp
//
//  Created by Tasnim Haque on 3/20/26.
//

import SwiftUI

@main
struct SwiftBookAppApp: App {
    @StateObject var mainVM = MainAppViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainVM)
        }
    }
}
