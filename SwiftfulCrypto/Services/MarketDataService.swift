//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 04/06/2024.
//

import Combine
import Foundation

class MarketDataService {
    @Published var marketData: MarketData? = nil

    private var subscription: AnyCancellable?

    init() {
        fetchMarketData()
    }

    private func fetchMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            return
        }

        subscription = NetworkingManager.shared.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkingManager.shared.handleCompletion,
                receiveValue: { [weak self] globalData in
                    self?.marketData = globalData.data
                    self?.subscription?.cancel()
                }
            )
    }
}
