//
//  CoinDetailDataService.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 06/06/2024.
//

import Combine
import Foundation

class CoinDetailDataService {
    @Published var coinDetail: CoinDetail? = nil
    
    let coin: Coin
    private var subscription: AnyCancellable?
    
    init(coin: Coin) {
        self.coin = coin
        fetchCoinDetail()
    }
    
    func fetchCoinDetail() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else { return }
        
        subscription = NetworkingManager.shared.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkingManager.shared.handleCompletion,
                receiveValue: { [weak self] coinDetail in
                    self?.coinDetail = coinDetail
                    self?.subscription?.cancel()
                }
            )
    }
}
