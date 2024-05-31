//
//  ContentView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()

            VStack {
                Text("Hello World")
            }
        }
    }
}

#Preview {
    ContentView()
}
