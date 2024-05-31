//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 31/05/2024.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject var viewModel: CoinImageViewModel

    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }

    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: Mock.coin)
}
