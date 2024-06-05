//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showEditPortfolioView: Bool = false

    var body: some View {
        ZStack {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showEditPortfolioView) {
                    EditPortfolioView()
                        .environmentObject(viewModel)
                }

            // content layer
            VStack {
                header

                HomeStatisticsView(showPortfolio: $showPortfolio)

                SearchBarView(searchText: $viewModel.searchText)

                columnTitles

                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                } else {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }

                Spacer(minLength: 0)
            }
        }
    }
}

extension HomeView {
    private var header: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
                .onTapGesture {
                    if showPortfolio {
                        showEditPortfolioView.toggle()
                    }
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(
                    Angle(degrees: showPortfolio ? 180 : 0)
                )
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
        }
        .listStyle(.plain)
    }

    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
        }
        .listStyle(.plain)
    }

    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .navigationBarHidden(true)
            .environmentObject(Mock.homeViewModel)
    }
}
