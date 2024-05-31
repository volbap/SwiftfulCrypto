//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    @StateObject private var homeViewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(homeViewModel)
        }
    }
}
