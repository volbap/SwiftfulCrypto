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
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()

    enum SortOption {
        case rank, rankReversed
        case holdings, holdingsReversed
        case price, priceReversed
    }

    init() {
        addSubscribers()
    }

    func addSubscribers() {
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$coins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)

        // updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapPortfolio)
            .sink { [weak self] coins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins)
            }
            .store(in: &cancellables)

        // updates statistics
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapStatistics)
            .sink { [weak self] statistics in
                self?.statistics = statistics
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    func reloadData() {
        isLoading = true
        coinDataService.fetchCoins()
        marketDataService.fetchMarketData()
        HapticManager.shared.notification(type: .success)
    }

    // MARK: - Private

    private func filterAndSortCoins(text: String, coins: [Coin], option: SortOption) -> [Coin] {
        var result = filterCoins(text: text, coins: coins)
        sort(&result, option: option)
        return result
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

    private func sort(_ coins: inout [Coin], option: SortOption) {
        switch option {
        case .rank, .holdings: coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed: coins.sort { $0.rank > $1.rank }
        case .price: coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed: coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }

    private func sortPortfolioCoinsIfNeeded(_ coins: [Coin]) -> [Coin] {
        // will only sort by holdings or reverseHoldings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default:
            return coins
        }
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

    private func mapStatistics(marketData: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
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

        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)

        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)

        let percentageChange = (portfolioValue - previousValue) / previousValue

        let portfolio = Statistic(
            title: "Portfolio Value",
            value: portfolioValue.toCurrency(),
            percentageChange: percentageChange
        )
        return [marketCap, volume, btcDominance, portfolio]
    }
}
