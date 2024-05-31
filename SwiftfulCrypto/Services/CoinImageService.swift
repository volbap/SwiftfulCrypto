//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import Combine
import SwiftUI

class CoinImageService {
    @Published var image: UIImage? = nil

    private var imageSubscription: AnyCancellable?

    init(urlString: String) {
        fetchCoinImage(urlString: urlString)
    }

    private func fetchCoinImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        imageSubscription = NetworkingManager.shared.download(url: url)
            .tryMap { data -> UIImage? in
                UIImage(data: data)
            }
            .sink(
                receiveCompletion: NetworkingManager.shared.handleCompletion,
                receiveValue: { [weak self] image in
                    self?.image = image
                    self?.imageSubscription?.cancel()
                }
            )
    }
}
