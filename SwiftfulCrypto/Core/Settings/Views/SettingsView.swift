//
//  SettingsView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 10/06/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    private let defaultURL = URL(string: "https://www.google.com")!
    private let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    private let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    private let coingeckoURL = URL(string: "https://www.coingecko.com")!
    private let personalURL = URL(string: "https://about.me/volbap")!

    var body: some View {
        NavigationView {
            List {
                swiftfulThinkingSection
                coinGeckoSection
                developerSection
                applicationSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    closeButton
                }
            }
        }
    }
}

extension SettingsView {
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }

    private var swiftfulThinkingSection: some View {
        Section("Swiftful Thinking") {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @SwiftfulThinking course on YouTube. It uses MVVM Architecture, Combine, and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on YouTube! 🥳", destination: youtubeURL)
            Link("Support his coffee addiction ☕️", destination: coffeeURL)
        }
    }

    private var coinGeckoSection: some View {
        Section("CoinGecko") {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko 🦎", destination: coingeckoURL)
        }
    }

    private var developerSection: some View {
        Section("Developer") {
            VStack(alignment: .leading) {
                Text("This app was developed by Pablo Villar. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit my website 👨🏻‍💻", destination: personalURL)
        }
    }

    private var applicationSection: some View {
        Section("Application") {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }
    }
}

#Preview {
    SettingsView()
}
