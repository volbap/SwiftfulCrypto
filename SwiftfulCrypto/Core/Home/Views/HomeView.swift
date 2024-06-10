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
    @State private var showSettingsView: Bool = false
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView: Bool = false

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
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() }
            )
        )
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
                    } else {
                        showSettingsView.toggle()
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
                    .onTapGesture {
                        segue(to: coin)
                    }
            }
        }
        .listStyle(.plain)
    }

    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .onTapGesture {
                        segue(to: coin)
                    }
            }
        }
        .listStyle(.plain)
    }

    private func segue(to coin: Coin) {
        selectedCoin = coin
        showDetailView = true
    }

    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed ? 1 : 0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation {
                    viewModel.sortOption = (viewModel.sortOption == .rank)
                        ? .rankReversed
                        : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed ? 1 : 0)
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.sortOption = (viewModel.sortOption == .holdings)
                            ? .holdingsReversed
                            : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption == .price || viewModel.sortOption == .priceReversed ? 1 : 0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation {
                    viewModel.sortOption = (viewModel.sortOption == .price)
                        ? .priceReversed
                        : .price
                }
            }

            Button {
                withAnimation(.linear(duration: 2.0)) {
                    viewModel.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
                    .rotationEffect(
                        Angle(degrees: viewModel.isLoading ? 360 : 0),
                        anchor: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/
                    )
            }
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
