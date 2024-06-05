//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var statistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }

    func addSubscribers() {
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$coins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)

        // updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapPortfolio)
            .sink { [weak self] coins in
                self?.portfolioCoins = coins
            }
            .store(in: &cancellables)

        // updates statistics
        marketDataService.$marketData
            .map(mapStatistics)
            .sink { [weak self] statistics in
                self?.statistics = statistics
            }
            .store(in: &cancellables)
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        let filteredCoins = coins.filter { coin -> Bool in
            coin.name.lowercased().contains(lowercasedText)
                || coin.symbol.lowercased().contains(lowercasedText)
                || coin.id.lowercased().contains(lowercasedText)
        }
        return filteredCoins
    }

    private func mapPortfolio(coins: [Coin], entities: [PortfolioEntity]) -> [Coin] {
        // we must return the coins that are portfolio entities
        coins.compactMap { coin -> Coin? in
            guard let entity = entities.first(where: { $0.coinID == coin.id }) else {
                return nil // coin not in portfolio
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }

    private func mapStatistics(from marketData: MarketData?) -> [Statistic] {
        guard let data = marketData else {
            return []
        }
        let marketCap = Statistic(
            title: "Market Cap",
            value: data.marketCap,
            percentageChange: data.marketCapChangePercentage24HUsd
        )
        let volume = Statistic(
            title: "24h Volume",
            value: data.volume
        )
        let btcDominance = Statistic(
            title: "BTC Dominance",
            value: data.btcDominance
        )
        let portfolioValue = Statistic(
            title: "Portfolio Value",
            value: "$0.00",
            percentageChange: 0
        )
        return [marketCap, volume, btcDominance, portfolioValue]
    }
}
