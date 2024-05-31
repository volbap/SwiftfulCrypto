//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.allCoins.append(Mock.coin)
            self.portfolioCoins.append(Mock.coin)
        }
    }
}
