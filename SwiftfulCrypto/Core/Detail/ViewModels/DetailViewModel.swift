//
//  DetailViewModel.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 06/06/2024.
//

import Combine
import Foundation

class DetailViewModel: ObservableObject {
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()

    init(coin: Coin) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }

    private func addSubscribers() {
        coinDetailService.$coinDetail
            .sink { coinDetail in
                print("RECEIVED COIN DETAIL DATA")
                print(coinDetail ?? "nil")
            }
            .store(in: &cancellables)
    }
}
