//
//  EditPortfolioView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 04/06/2024.
//

import SwiftUI

struct EditPortfolioView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: Coin?
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)

                    coinsHorizontalList

                    if let coin = selectedCoin {
                        portfolioInputSection(for: coin)
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            }
            .onChange(of: viewModel.searchText) {
                if viewModel.searchText == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

extension EditPortfolioView {
    private var coinsHorizontalList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                let coinsToShow = viewModel.searchText.isEmpty
                    ? viewModel.portfolioCoins
                    : viewModel.allCoins
                ForEach(coinsToShow) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(to: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id
                                        ? Color.theme.green
                                        : Color.clear,
                                    lineWidth: 1
                                )
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }

    private func updateSelectedCoin(to coin: Coin) {
        selectedCoin = coin
        if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings
        {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }

    private func getCurrentValue() -> Double {
        guard let quantity = Double(quantityText) else {
            return 0
        }
        return quantity * (selectedCoin?.currentPrice ?? 0)
    }

    private func portfolioInputSection(for coin: Coin) -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(coin.symbol.uppercased()):")
                Spacer()
                Text(coin.currentPrice.toCurrency(maxDecimals: 6))
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().toCurrency())
            }
        }
        .padding()
        .font(.headline)
    }

    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1 : 0)
            Button {
                saveChanges()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText))
                    ? 1 : 0
            )
        }
        .font(.headline)
    }

    private func saveChanges() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }

        // save to portfolio
        viewModel.updatePortfolio(coin: coin, amount: amount)

        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }

        // hide keyboard
        UIApplication.shared.endEditing()

        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }

    private func removeSelectedCoin() {
        selectedCoin = nil
        viewModel.searchText = ""
    }
}

#Preview {
    EditPortfolioView()
        .environmentObject(Mock.homeViewModel)
}
