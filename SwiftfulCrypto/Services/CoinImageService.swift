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
    let coin: Coin

    private var imageSubscription: AnyCancellable?
    private let fileManager = LocalFileManager.shared
    private let folderName = "coin_images"
    private let imageName: String

    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }

    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        imageSubscription = NetworkingManager.shared.download(url: url)
            .tryMap { data -> UIImage? in
                UIImage(data: data)
            }
            .sink(
                receiveCompletion: NetworkingManager.shared.handleCompletion,
                receiveValue: { [weak self] image in
                    guard let self = self, let downloadedImage = image else {
                        return
                    }
                    self.fileManager.saveImage(
                        downloadedImage,
                        imageName: self.imageName,
                        folderName: self.folderName
                    )
                    self.image = downloadedImage
                    self.imageSubscription?.cancel()
                }
            )
    }
}
