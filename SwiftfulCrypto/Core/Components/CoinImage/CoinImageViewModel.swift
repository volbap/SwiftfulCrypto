//
//  CoinImageViewModel.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import Combine
import SwiftUI

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false

    private let coin: Coin
    private let imageService: CoinImageService
    private var cancellables = Set<AnyCancellable>()

    init(coin: Coin) {
        self.coin = coin
        self.imageService = CoinImageService(urlString: coin.image)
        addSubscribers()
    }

    private func addSubscribers() {
        isLoading = true
        imageService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
    }
}
