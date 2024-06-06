//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by Pablo Villar on 06/06/2024.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel

    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }

    var body: some View {
        Text("Hello")
    }
}

#Preview {
    DetailView(coin: Mock.coin)
}
