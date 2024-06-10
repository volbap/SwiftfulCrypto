//
//  CoinDataService.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import Combine
import Foundation

class CoinDataService {
    @Published var coins: [Coin] = []

    private var subscription: AnyCancellable?

    init() {
        fetchCoins()
    }

    func fetchCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else { return }

        subscription = NetworkingManager.shared.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkingManager.shared.handleCompletion,
                receiveValue: { [weak self] coins in
                    self?.coins = coins
                    self?.subscription?.cancel()
                }
            )
    }
}
